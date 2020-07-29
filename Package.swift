// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "Vaporvisor",
    products: [
        .library(name: "Vaporvisor", targets: ["Vaporvisor"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/MaxDesiatov/XMLCoder.git", from: "0.11.1")
    ],
    targets: [
        .target(name: "Vaporvisor", dependencies: ["Vapor", "XMLCoder"]),
        .testTarget(name: "VaporvisorTests", dependencies: ["Vaporvisor"])
    ]
)