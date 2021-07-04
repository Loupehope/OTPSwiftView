// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OTPSwiftView",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "OTPSwiftView", targets: ["OTPSwiftView"]),
    ],
    dependencies: [
        .package(url: "https://github.com/TouchInstinct/LeadKit", from: .init(0, 3, 9))
    ],
    targets: [
        .target(name: "OTPSwiftView", dependencies: ["TIUIKitCore"], path: "Sources"),
    ]
)
