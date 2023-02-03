// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "LogsManager",
    platforms: [
        .iOS(.v11),
        .macOS(.v10_13),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        .library(
            name: "LogsManager",
            targets: ["LogsManager"]
        ),
        .library(
            name: "LogsManagerExtensionUnsafe",
            targets: ["LogsManagerExtensionUnsafe"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/APUtils/APExtensions.git", .upToNextMajor(from: "12.0.3")),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.7.2"),
        .package(url: "https://github.com/anton-plebanovich/RoutableLogger.git", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "LogsManagerExtensionUnsafe",
            dependencies: [
                "LogsManager",
            ],
            path: "LogsManager/ExtensionUnsafeClasses",
            swiftSettings: [
                .define("SPM"),
            ]
        ),
        .target(
            name: "LogsManager",
            dependencies: [
                "LogsManagerObjc",
                .product(name: "APExtensionsOccupiable", package: "APExtensions"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack"),
                .product(name: "RoutableLogger", package: "RoutableLogger"),
            ],
            path: "LogsManager",
            exclude: [
                "Classes/_Message Loggers/_Base/_DDTTYLogger.h",
                "Classes/_Message Loggers/_Base/_DDTTYLogger.m",
                "RoutableLogger",
                "ExtensionUnsafeClasses",
            ],
            sources: [
                "Classes",
                "Shared",
            ],
            swiftSettings: [
                .define("SPM"),
            ]
        ),
        .target(
            name: "LogsManagerObjc",
            dependencies: [
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
            ],
            path: "LogsManager/Classes/_Message Loggers/_Base",
            sources: [
                "_DDTTYLogger.h",
                "_DDTTYLogger.m",
            ],
            publicHeadersPath: "",
            cSettings: [
                .define("SPM"),
            ]
        ),
    ]
)
