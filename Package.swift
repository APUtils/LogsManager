// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "RoutableLogger",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v3),
    ],
    products: [
        .library(
            name: "RoutableLogger",
            targets: ["RoutableLogger"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RoutableLogger",
            dependencies: [],
            path: "LogsManager",
            sources: ["RoutableLogger", "Shared"],
            swiftSettings: [
                .define("SPM"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
