import Foundation
import NIOHTTP1

public struct NIOHTTPClientResponse {
    public internal(set) var responseHead: HTTPResponseHead
    public internal(set) var body: (data: Data, string: String)

    public var status: HTTPResponseStatus {
        return responseHead.status
    }
    public var version: HTTPVersion {
        return responseHead.version
    }

    public var description: String {
        var desc: [String] = []
        desc.append("HTTP/\(responseHead.version.major).\(responseHead.version.minor) \(responseHead.status.code) \(responseHead.status.reasonPhrase)")
        desc.append("\n")
        for header in responseHead.headers {
            desc.append("\(header.name): \(header.value)")
        }
        desc.append("\n")
        desc.append(body.string)
        return desc.joined(separator: "\n")
    }

}
