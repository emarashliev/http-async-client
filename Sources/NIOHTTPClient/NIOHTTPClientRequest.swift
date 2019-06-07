import Foundation
import NIOHTTP1

public struct NIOHTTPClientRequest {

    public let method: HTTPMethod
    public let url: URL
    public let version: HTTPVersion
    public let headers: HTTPHeaders
    public let body: Data
    let host: String
    let uri: String
    let port: Int

    public var description: String {
        var desc: [String] = []
        desc.append("\(method) \(url) HTTP/\(version.major).\(version.minor)")
        desc.append(headers.description)
        desc.append(String(data: body, encoding: .utf8) ?? "")
        return desc.joined(separator: "\n")
    }


    public init(
        method: HTTPMethod = .GET,
        url: URL,
        version: HTTPVersion = .init(major: 2, minor: 0),
        headers: HTTPHeaders = .init(),
        body: Data = .init()
    ) throws {
        self.method = method
        self.url = url
        self.version = version
        self.headers = headers
        self.body = body

        guard let maybeHost = url.host else {
            throw NIOHTTPClientError.URLDoesNotHaveHost
        }
        host = maybeHost

        if  url.absoluteURL.path.isEmpty {
            uri = "/"
        } else {
            uri = url.absoluteURL.path
        }

         port = url.port ?? 443
    }
}
