// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AppDependencies",
    platforms: [.iOS(.v17), .watchOS(.v10)],
    products: [
        .library(
            name: "AchievementsViewFeature",
            targets: ["AchievementsViewFeature"]),
        .library(
            name: "RequestPermissionsViewFeature",
            targets: ["RequestPermissionsViewFeature"]),
        .library(
            name: "WorkoutTypeViewFeature",
            targets: ["WorkoutTypeViewFeature"]),
        .library(
            name: "WorkoutsViewFeature",
            targets: ["WorkoutsViewFeature"]),
        .library(
            name: "WorkoutsClient",
            targets: ["WorkoutsClient"]),
        .library(
            name: "WorkoutsClientLive",
            targets: ["WorkoutsClientLive"]),
    ],
    targets: [
        .target(
            name: "AchievementsViewFeature",
            dependencies: ["WorkoutsClient",
                           "WorkoutsViewFeature",
                           "RequestPermissionsViewFeature",
                           "WorkoutTypeViewFeature"]),
        .target(
            name: "RequestPermissionsViewFeature",
            dependencies: ["WorkoutsClient", "WorkoutsViewFeature"]),
        .target(
            name: "WorkoutTypeViewFeature",
            dependencies: ["WorkoutsClient"]),
        .target(
            name: "WorkoutsViewFeature",
            dependencies: ["WorkoutsClient"]),
        .target(
            name: "WorkoutsClient",
            path: "Sources/WorkoutsClient/Client"),
        .target(
            name: "WorkoutsClientLive",
            dependencies: ["WorkoutsClient"],
            path: "Sources/WorkoutsClient/Live"),
    ]
)
