// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "OmakaseLauncher",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "OmakaseLauncher", targets: ["OmakaseLauncher"]),
    ],
    targets: [
        .executableTarget(name: "OmakaseLauncher"),
    ]
)
