// swift-tools-version:5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "LogsManager",
    platforms: [
        .iOS(.v12),
        .macOS(.v10_13),
        .tvOS(.v12),
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
        .package(url: "https://github.com/APUtils/APExtensions.git", .upToNextMajor(from: "14.0.0")),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", from: "3.7.2"),
        .package(url: "https://github.com/anton-plebanovich/RoutableLogger", .upToNextMajor(from: "1.0.0")),
    ],
    targets: [
        .target(
            name: "LogsManagerExtensionUnsafe",
            dependencies: [
                "LogsManager",
            ],
            path: "LogsManager",
            sources: [
                "ExtensionUnsafeClasses",
            ],
            resources: [
                .process("Privacy/LogsManager.Core/PrivacyInfo.xcprivacy")
            ],
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
            resources: [
                .process("Privacy/LogsManager.Core/PrivacyInfo.xcprivacy")
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
            path: "LogsManager",
            sources: [
                "Classes/_Message Loggers/_Base/_DDTTYLogger.h",
                "Classes/_Message Loggers/_Base/_DDTTYLogger.m",
            ],
            resources: [
                .process("Privacy/LogsManager.Core/PrivacyInfo.xcprivacy")
            ],
            publicHeadersPath: "",
            cSettings: [
                .define("SPM"),
            ]
        ),
    ]
)
