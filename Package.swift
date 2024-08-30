// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "lunarSwift",
    platforms: [
        .macOS(.v10_15),  // Set the minimum macOS version to 10.15
        .iOS(.v13),      // Specify the minimum iOS version if needed
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.

        .library(
            name: "lunarSwift",
            targets: ["lunarSwift"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.

        .target(
            name: "lunarSwift",
            dependencies: [],
            path: "Sources/lunarSwift",
            sources: ["classdef.swift", "config.swift", "utils.swift"]),
        .testTarget(
            name: "lunarSwiftTests",
            dependencies: ["lunarSwift"],
            path: "Tests/lunarSwiftTests")
    ]
)
