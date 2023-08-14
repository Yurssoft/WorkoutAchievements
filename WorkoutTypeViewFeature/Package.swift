// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "WorkoutTypeViewFeature",
    platforms: [.iOS(.v17), .watchOS(.v10)],
    products: [
        .library(
            name: "WorkoutTypeViewFeature",
            targets: ["WorkoutTypeViewFeature"]),
    ],
    dependencies: [
        .package(path: "../WorkoutsClient")
    ],
    targets: [
        .target(
            name: "WorkoutTypeViewFeature",
            dependencies: ["WorkoutsClient"]),
    ]
)
