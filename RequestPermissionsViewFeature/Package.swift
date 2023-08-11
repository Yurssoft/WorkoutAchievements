// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "RequestPermissionsViewFeature",
    platforms: [.iOS(.v17), .watchOS(.v10)],
    products: [
        .library(
            name: "RequestPermissionsViewFeature",
            targets: ["RequestPermissionsViewFeature"]),
    ],
    dependencies: [
        .package(path: "../WorkoutsClient"),
        .package(path: "../WorkoutsViewFeature")
    ],
    targets: [
        .target(
            name: "RequestPermissionsViewFeature",
            dependencies: ["WorkoutsClient", "WorkoutsViewFeature"]),
    ]
)
