// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhotoWidgetSpm",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PhotoWidgetSpm",
            targets: ["PhotoWidgetSpm"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", .upToNextMajor(from: "6.2.0")),
    ],
    targets: [
        .target(
            name: "PhotoWidgetSpm",
            dependencies: [
                "SFSafeSymbols"
            ]
        ),
        .testTarget(
            name: "PhotoWidgetSpmTests",
            dependencies: ["PhotoWidgetSpm"]
        ),
    ]
)
