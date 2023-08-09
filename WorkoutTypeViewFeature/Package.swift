// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "WorkoutTypeViewFeature",
    platforms: [.iOS(.v17)],
    products: [
        .library(
            name: "WorkoutTypeViewFeature",
            targets: ["WorkoutTypeViewFeature"]),
    ],
    targets: [
        .target(
            name: "WorkoutTypeViewFeature"),
    ]
)
