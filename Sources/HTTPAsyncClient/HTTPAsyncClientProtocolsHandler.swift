import NIO
import NIOTLS
import NIOSSL

final class HTTPAsyncClientProtocolsHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    typealias InboundOut = ByteBuffer

    var bytesSeen = 0

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let buffer = self.unwrapInboundIn(data)
        bytesSeen += buffer.readableBytes
        context.fireChannelRead(data)
    }

    func userInboundEventTriggered(context: ChannelHandlerContext, event: Any) {
        if self.bytesSeen == 0 {
            if case let event = event as? TLSUserEvent, event == .shutdownCompleted || event == .handshakeCompleted(negotiatedProtocol: nil) {
                context.fireErrorCaught(HTTPAsyncClientError.serverDoesNotSpeakHTTP2)
                return
            }
        }
        context.fireUserInboundEventTriggered(event)
    }

    func errorCaught(context: ChannelHandlerContext, error: Swift.Error) {
        if self.bytesSeen == 0 {
            switch error {
            case NIOSSLError.uncleanShutdown,
                 is IOError where (error as! IOError).errnoCode == ECONNRESET:
                // this is very highly likely a server doesn't speak HTTP/2 problem
                context.fireErrorCaught(HTTPAsyncClientError.serverDoesNotSpeakHTTP2)
                return
            default:
                ()
            }
        }
        context.fireErrorCaught(error)
    }
}
