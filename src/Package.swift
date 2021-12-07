// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "HexletBasics",
    products: [
        .library(
            name: "HexletBasics",
            type: .static,
            targets: ["HexletBasics"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "HexletBasics",
            dependencies: [])
    ]
)
