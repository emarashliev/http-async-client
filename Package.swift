// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-nio-http-client",

     products: [
        .executable(name: "NIOHTTPClientExample", targets: ["NIOHTTPClientExample"]),
        .library(name: "NIOHTTPClient", targets: ["NIOHTTPClient"]),
     ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-nio", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-nio-ssl", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-nio-http2", from: "1.0.0"),
    ],

    targets: [
        .target(name: "NIOHTTPClientExample", dependencies: ["NIOHTTPClient"]),
        .target(
            name: "NIOHTTPClient",
            dependencies: ["NIO", "NIOSSL", "NIOHTTP1", "NIOHTTP2", "NIOTLS"]
        ),
        .testTarget(name: "NIOHTTPClientTests", dependencies: ["NIOHTTPClient"]),
    ]
)
