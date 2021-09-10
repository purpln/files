// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Files",
    platforms: [.iOS(.v10), .macOS(.v10_10), .tvOS(.v9), .watchOS(.v2)],
    products: [.library(name: "Files", targets: ["Files"])],
    dependencies: [],
    targets: [.target(name: "Files")]
)
