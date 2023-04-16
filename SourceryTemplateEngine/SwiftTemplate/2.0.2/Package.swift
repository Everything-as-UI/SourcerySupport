// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftTemplate",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "SwiftTemplate", targets: ["SwiftTemplate"])
    ],
    dependencies: [
        .package(url: "https://github.com/Everything-as-UI/SwiftLangUI.git", branch: "main")
    ],
    targets: [
        .target(name: "SourceryRuntime"),
        .target(name: "TemplateKit", dependencies: ["SwiftLangUI"]),
        .executableTarget(name: "SwiftTemplate", dependencies: ["SourceryRuntime", "TemplateKit"])
    ]
)
