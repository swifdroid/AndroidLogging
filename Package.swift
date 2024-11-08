// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "AndroidLogging",
  platforms: [
    .macOS(.v10_15),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to
    // other packages.
    .library(
      name: "AndroidLogging",
      targets: ["AndroidLogging"]
    ),
  ],
  dependencies: [
    .package(
      url: "https://github.com/apple/swift-log",
      branch: "main"
    ),
  ],
  targets: [
    .target(
      name: "CAndroidLogging",
      linkerSettings: [.linkedLibrary("android")]
    ),
    .target(
      name: "AndroidLogging",
      dependencies: [
        "CAndroidLogging",
        .product(name: "Logging", package: "swift-log"),
      ],
      swiftSettings: [.swiftLanguageMode(.v5)]
    ),
  ]
)
