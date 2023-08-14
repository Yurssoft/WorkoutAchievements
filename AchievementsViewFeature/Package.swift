// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AchievementsViewFeature",
    platforms: [.iOS(.v17), .watchOS(.v10)],
    products: [
        .library(
            name: "AchievementsViewFeature",
            targets: ["AchievementsViewFeature"]),
    ],
    dependencies: [
        .package(path: "../WorkoutsClient"),
        .package(path: "../WorkoutsViewFeature"),
        .package(path: "../RequestPermissionsViewFeature"),
        .package(path: "../WorkoutTypeViewFeature")
    ],
    targets: [
        .target(
            name: "AchievementsViewFeature",
            dependencies: ["WorkoutsClient",
                           "WorkoutsViewFeature",
                           "RequestPermissionsViewFeature",
                           "WorkoutTypeViewFeature"])
    ]
)
