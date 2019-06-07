
public enum NIOHTTPClientError: Error {
    case URLDoesNotHaveHost
    case serverDoesNotSpeakHTTP2
    case didNotReceiveFullResponse
}
