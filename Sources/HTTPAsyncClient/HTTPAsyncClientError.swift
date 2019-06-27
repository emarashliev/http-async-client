
public enum HTTPAsyncClientError: Error {
    case URLDoesNotHaveHost
    case serverDoesNotSpeakHTTP2
    case didNotReceiveFullResponse
}
