# AndroidLogging

Swift logging backend for Android. It uses original `swift-log`.

## Installation

```swift
// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "MyAndroidApp",
    products: [
        .library(name: "App", type: .dynamic, targets: ["App"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log", from: "1.6.2"),
        .package(url: "https://github.com/swifdroid/AndroidLogging", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "App", dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(
                    name: "AndroidLogging",
                    package: "AndroidLogging", condition: .when(platforms: [.android])
                )
            ]
        )
    ]
)
```

## Usage

Do it once
```swift
#if canImport(Android)
LoggingSystem.bootstrap(AndroidLogHandler.taggedBySource)
#endif
```

Then as usual
```swift
let logger = Logger(label: "🐦‍🔥 SWIFT")
logger.info("🚀 Hello World!")
```
