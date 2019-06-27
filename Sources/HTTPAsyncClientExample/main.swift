import Foundation
import NIO
import HTTPAsyncClient

let url = URL(string: "https://www.google.com")!
let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
let client = try! HTTPAsyncClient(on: group)
let response  = try! client.send(request: HTTPAsyncClientRequest(url: url)).wait()
print(response.description)
