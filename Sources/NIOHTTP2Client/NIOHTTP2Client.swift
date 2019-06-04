import Foundation
import NIO
import NIOHTTP1
import NIOHTTP2
import NIOSSL

public final class NIOHTTP2Client {

    private let sslContext: NIOSSLContext
    private let responseReceivedPromise: EventLoopPromise<[HTTPClientResponsePart]>
    private let eventLoopGroup: EventLoopGroup

    public init(
        _ tlsConfig: TLSConfiguration = .forClient(applicationProtocols: ["h2"]),
        on eventLoopGroup: EventLoopGroup
    ) throws {
        self.eventLoopGroup = eventLoopGroup
        self.sslContext = try NIOSSLContext(configuration: tlsConfig)
        self.responseReceivedPromise = eventLoopGroup
            .next()
            .makePromise(of: [HTTPClientResponsePart].self)
    }

    deinit {
        try? eventLoopGroup.syncShutdownGracefully()
    }

    public func send(request: HTTPRequest) throws -> EventLoopFuture<HTTPResponse> {
        return try bootstrap(request: request)
            .connect(host: request.host, port: request.port)
            .flatMap { channel in
                return self.responseReceivedPromise.futureResult
                    .map { responseParts -> HTTPResponse in
                        var data = Data()
                        var string = String()
                        var responseHead: HTTPResponseHead!
                        for part in responseParts {
                            switch part {
                            case .head(let resHead):
                                responseHead = resHead
                            case .body(var buffer):
                                var bufferCopy = buffer
                                //read buffer as Data
                                let maybeBytes = buffer.withUnsafeReadableBytes { ptr in
                                    buffer.readBytes(length: ptr.count)
                                }
                                if let bytes = maybeBytes {
                                    data.append(contentsOf: bytes)
                                }

                                //read buffer as String
                                let maybeString = bufferCopy.withUnsafeReadableBytes { ptr in
                                    bufferCopy.readString(length: ptr.count)
                                }
                                if let str = maybeString {
                                    string.append(contentsOf: str)
                                }

                            case .end(_):
                                return HTTPResponse(
                                    responseHead: responseHead,
                                    body: (data: data, string: string)
                                )
                            }
                        }

                        channel.pipeline
                            .fireErrorCaught(NIOHTTP2ClientError.didNotReceiveFullResponse)
                        return HTTPResponse(
                            responseHead: responseHead,
                            body: (data: data, string: string)
                        )
                }
        }
    }


    private func bootstrap(request: HTTPRequest) throws -> ClientBootstrap {
        let sslHandler = try NIOSSLClientHandler(
            context: self.sslContext,
            serverHostname: request.host
        )

        return ClientBootstrap(group: eventLoopGroup)
            .channelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .channelInitializer { channel in
                return channel.pipeline.addHandler(sslHandler)
                    .flatMap {
                        channel.configureHTTP2Pipeline(mode: .client) { channel, _ in
                            return channel.eventLoop.makeSucceededFuture(())
                        }
                    }
                    .flatMap { http2Multiplexer -> EventLoopFuture<Void> in
                        let protocolsHandler = ProtocolsHandler()
                        let errorHandler = ErrorHandler(responseReceivedPromise: self.responseReceivedPromise)
                        return channel.pipeline
                            .addHandler(protocolsHandler, position: .after(sslHandler))
                            .flatMap {
                                channel.pipeline.addHandler(errorHandler)
                            }
                            .map { _ in
                                let requestStreamInitializer = self.requestStreamInitializer(
                                    request: request
                                )

                                http2Multiplexer.createStreamChannel(
                                    promise: nil,
                                    requestStreamInitializer
                                )
                            }
                    }
        }
    }


    private func requestStreamInitializer(request: HTTPRequest) -> ((
        _ channel: Channel,
        _ streamID: HTTP2StreamID
    ) -> EventLoopFuture<Void>) {
        let requestHandler = HTTPClientHandler(
            request: request,
            responsePromise: responseReceivedPromise
        )

        return { (_ channel: Channel, _ streamID: HTTP2StreamID) -> EventLoopFuture<Void> in
            channel.pipeline.addHandlers(
                [HTTP2ToHTTP1ClientCodec(streamID: streamID, httpProtocol: .https), requestHandler],
                position: .last
            )
        }
    }

}
