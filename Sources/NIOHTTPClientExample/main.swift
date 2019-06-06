import Foundation
import NIO
import NIOHTTPClient

let url = URL(string: "https://www.google.com")!
let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
let client = try! NIOHTTPClient(on: group)
let response  = try! client.send(request: NIOHTTPClientRequest(url: url)).wait()
print(response.description)
