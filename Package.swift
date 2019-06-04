// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-nio-http2-client",

     products: [
        .executable(name: "NIOHTTP2ClientExample", targets: ["NIOHTTP2ClientExample"]),
        .library(name: "NIOHTTP2Client", targets: ["NIOHTTP2Client"]),
     ],

    dependencies: [
        .package(url: "https://github.com/vapor/http", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-nio", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-nio-ssl", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-nio-http2", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-nio-extras", from: "1.0.0"),
    ],

    targets: [
        .target(name: "NIOHTTP2ClientExample", dependencies: ["NIOHTTP2Client"]),
        .target(
            name: "NIOHTTP2Client",
            dependencies: ["NIO", "NIOSSL", "NIOHTTP1", "NIOHTTP2", "NIOTLS", "NIOExtras"]
        ),
        .testTarget(name: "NIOHTTP2ClientTests", dependencies: ["NIOHTTP2Client"]),
    ]
)
