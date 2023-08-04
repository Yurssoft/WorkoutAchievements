// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "WorkoutsViewFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "WorkoutsViewFeature",
            targets: ["WorkoutsViewFeature"]),
    ],
    dependencies: [
        .package(path: "../WorkoutsClient")
    ],
    targets: [
        .target(
            name: "WorkoutsViewFeature",
            dependencies: ["WorkoutsClient"]),
    ]
)
