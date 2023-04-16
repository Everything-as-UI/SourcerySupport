// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TemplateEngine-Example",
    products: [
        .library(name: "TemplateEngine-Example", targets: ["TemplateEngine-Example"])
    ],
    dependencies: [],
    targets: [
        .target(name: "TemplateEngine-Example", dependencies: []),
        .testTarget(name: "TemplateEngine-ExampleTests", dependencies: ["TemplateEngine-Example"])
    ]
)
