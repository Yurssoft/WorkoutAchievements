// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "WorkoutsClient",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "WorkoutsClient",
            targets: ["WorkoutsClient"]),
        .library(
            name: "WorkoutsClientLive",
            targets: ["WorkoutsClientLive"]),
    ],
    targets: [
        .target(
            name: "WorkoutsClient"),
        .target(
            name: "WorkoutsClientLive",
            dependencies: ["WorkoutsClient"]),
        .testTarget(
            name: "WorkoutsClientTests",
            dependencies: ["WorkoutsClient"]),
    ]
)
