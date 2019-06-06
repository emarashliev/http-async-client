import NIO
import NIOHTTP1

final class NIOHTTPClientHandler: ChannelInboundHandler {
    typealias InboundIn = HTTPClientResponsePart
    typealias OutboundOut = HTTPClientRequestPart

    private let responsePromise: EventLoopPromise<[HTTPClientResponsePart]>
    private var responseAccumulator: [HTTPClientResponsePart] = []
    private let request: NIOHTTPClientRequest

    init(request: NIOHTTPClientRequest, responsePromise: EventLoopPromise<[HTTPClientResponsePart]>) {
        self.responsePromise = responsePromise
        self.request = request
    }

    func channelActive(context: ChannelHandlerContext) {
        assert(context.channel.parent!.isActive)
        var headers = request.headers
        var reqHead = HTTPRequestHead(
            version: request.version,
            method: request.method,
            uri: request.uri
        )
        let body = [UInt8](request.body)
        var buffer = context.channel.allocator.buffer(capacity: body.count)
        
        headers.add(name: "Host", value: request.host)
        reqHead.headers = headers
        buffer.writeBytes(body)
        context.write(wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
        context.write(wrapOutboundOut(.head(reqHead)), promise: nil)
        context.writeAndFlush(wrapOutboundOut(.end(request.headers)), promise: nil)
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let resPart = unwrapInboundIn(data)
        responseAccumulator.append(resPart)
        if case .end = resPart {
            responsePromise.succeed(responseAccumulator)
        }
    }
}
