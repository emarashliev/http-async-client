
public enum NIOHTTP2ClientError: Error {
    case URLDoesNotHaveHost
    case serverDoesNotSpeakHTTP2
    case didNotReceiveFullResponse
}
