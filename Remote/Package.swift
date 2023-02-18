// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Remote",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "Remote",
            targets: ["Remote"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Remote",
            dependencies: []),
        .testTarget(
            name: "RemoteTests",
            dependencies: ["Remote"]),
    ]
)
