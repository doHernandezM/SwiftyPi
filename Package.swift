// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyPi",
    platforms: [
        .macOS(.v11),
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "SwiftyPi",
            targets: ["SwiftyPi"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/uraimo/SwiftyGPIO.git", .exact("1.1.10")),
        .package(url: "https://github.com/doHernandezM/ManualStack.git", from:"1.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftyPi",
            dependencies: [
                .product(name: "SwiftyGPIO", package: "SwiftyGPIO"),
                .product(name: "ManualStack", package: "ManualStack")
            ]),
        .testTarget(
            name: "SwiftyPiTests",
            dependencies: ["SwiftyPi","ManualStack"]),
    ]
)
