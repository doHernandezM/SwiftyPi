// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyPi",
    platforms: [
        .macOS(.v10_15), ///This code should be back portable to 10.11/12 but the SyntextHighlighter needs v10_15.
        .iOS(.v13) ///Supports iOS without SyntextHighlighter
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
//        .package(url: "https://github.com/uraimo/SwiftyGPIO.git", .exact("1.1.10")),
//        .package(url: "https://github.com/doHernandezM/SwiftyLCD.git", .branch("main")),
        .package(url: "https://github.com/doHernandezM/Schwifty.git", .branch("main"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "SwiftyPi",
            dependencies: [
//                .product(name: "SwiftyGPIO", package: "SwiftyGPIO"),
//                .product(name: "SwiftyLCD", package: "SwiftyLCD"),
                .product(name: "Schwifty", package: "Schwifty"),
            ]),
        .testTarget(
            name: "SwiftyPiTests",
            dependencies: ["SwiftyPi"]),
    ]
)
