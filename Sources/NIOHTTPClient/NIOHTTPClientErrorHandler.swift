import NIO
import NIOHTTP1

final class NIOHTTPClientErrorHandler: ChannelInboundHandler {
    typealias InboundIn = Never

    private let responseReceivedPromise: EventLoopPromise<[HTTPClientResponsePart]>

    init(responseReceivedPromise: EventLoopPromise<[HTTPClientResponsePart]>) {
        self.responseReceivedPromise = responseReceivedPromise
    }

    func errorCaught(context: ChannelHandlerContext, error: Error) {
        responseReceivedPromise.fail(error)
        print(error)
        context.close(promise: nil)
    }
}
