// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TICodeView",
    platforms: [
        .iOS(.v10)
    ],
    products: [
        .library(
            name: "TICodeView",
            targets: ["TICodeView"]),
    ],
    targets: [
        .target(
            name: "TICodeView",
            path: "TICodeView/Sources"),
    ]
)
