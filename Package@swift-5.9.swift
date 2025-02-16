// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "composable-deep-link",
    platforms: [
        .watchOS(.v9),
        .iOS(.v16),
        .macOS(.v13),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "ComposableDeepLink",
            targets: ["ComposableDeepLink"]),
    ],
    targets: [
        .target(
            name: "ComposableDeepLink"),
        .testTarget(
            name: "ComposableDeepLinkTests",
            dependencies: ["ComposableDeepLink"]),
    ]
)
