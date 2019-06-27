// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "http-async-client",

     products: [
        .executable(name: "HTTPAsyncClientExample", targets: ["HTTPAsyncClientExample"]),
        .library(name: "HTTPAsyncClient", targets: ["HTTPAsyncClient"]),
     ],

    dependencies: [
        .package(url: "https://github.com/apple/swift-nio", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-nio-ssl", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-nio-http2", from: "1.0.0"),
    ],

    targets: [
        .target(name: "HTTPAsyncClientExample", dependencies: ["HTTPAsyncClient"]),
        .target(
            name: "HTTPAsyncClient",
            dependencies: ["NIO", "NIOSSL", "NIOHTTP1", "NIOHTTP2", "NIOTLS"]
        ),
        .testTarget(name: "HTTPAsyncClientTests", dependencies: ["HTTPAsyncClient"]),
    ]
)
