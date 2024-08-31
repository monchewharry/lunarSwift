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
        .library(name: "lunarSwift",targets: ["lunarSwift"]),
        .library(name: "baguaSwift",targets: ["baguaSwift"]),
    ],
    dependencies:[],
    targets: [
        .target(
            name: "lunarSwift",
            dependencies: [],
            path: "Sources/lunarSwift",
            sources: ["classdef.swift", "config.swift", "utils.swift"]
            ),
        .testTarget(
            name: "lunarSwiftTests",
            dependencies: ["lunarSwift"],
            path: "Tests/lunarSwiftTests"
            ),

        .target(
            name: "baguaSwift",
            dependencies: [],
            path: "Sources/baguaSwift",
            sources: ["config.swift", "utils.swift"],
            resources:[
                .process("Resources")
                ]
            ),
        .testTarget(
            name: "baguaSwiftTests",
            dependencies: ["baguaSwift"],
            resources:[
                .process("Resources")
                ]

            ),
    ]
)
