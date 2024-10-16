// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "LunarSwift",
    platforms: [.iOS(.v14), .macOS(.v13)],
    products: [
        .library(name: "LunarSwift", targets: ["LunarCalendar", "LunarPeople", "LunarBagua"]),
    ],
    dependencies: [],
    targets: [
        // Configuration target
        .target(
            name: "GlobalConfigs",
            dependencies: []
        ),
        // Subpackages
        .target(
            name: "LunarCalendar",
            dependencies: ["GlobalConfigs"]
        ),
        .target(
            name: "LunarPeople",
            dependencies: ["GlobalConfigs"]
        ),
        .target(
            name: "LunarBagua",
            dependencies: ["LunarConfigs", "LunarCalendar", "LunarPeople"]
        ),
        .testTarget(
            name: "LunarSwiftTests",
            dependencies: ["LunarCalendar", "LunarPeople", "LunarBagua"]
        ),
    ]
)
