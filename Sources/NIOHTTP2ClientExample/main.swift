import Foundation
import NIO
import NIOHTTP2Client

let url = URL(string: "https://www.google.com")!
let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
let client = try! NIOHTTP2Client(on: group)
let response  = try! client.send(request: HTTPRequest(url: url)).wait()
print(response.description)
