// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "composable-deep-link",
    platforms: [
        .watchOS(.v4),
        .iOS(.v16),
        .macOS(.v13),
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
