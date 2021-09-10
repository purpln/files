// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Files",
    platforms: [.iOS(.v10)],
    products: [.library(name: "Files", targets: ["Files"])],
    targets: [.target(name: "Files")]
)
