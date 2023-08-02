// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "WorkoutsClient",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "WorkoutsClient",
            targets: ["WorkoutsClient"]),
    ],
    targets: [
        .target(
            name: "WorkoutsClient"),
        .testTarget(
            name: "WorkoutsClientTests",
            dependencies: ["WorkoutsClient"]),
    ]
)
