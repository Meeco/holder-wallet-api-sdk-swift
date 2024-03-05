// swift-tools-version: 5.9
import PackageDescription

let package = Package(
	name: "MeecoHolderWalletApiSdk",
	platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .visionOS(.v1)],
    products: [
      .library(name: "MeecoHolderWalletApiSdk", targets: ["MeecoHolderWalletApiSdk"])
    ],
	dependencies: [
		.package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
		.package(url: "https://github.com/apple/swift-openapi-urlsession", from: "1.0.0")
	],
	targets: [
		.target(
			name: "MeecoHolderWalletApiSdk",
			dependencies: [
				.product(name: "OpenAPIRuntime", package: "swift-openapi-runtime"),
				.product(name: "OpenAPIURLSession", package: "swift-openapi-urlsession")
			]
		),
        .testTarget(
            name: "MeecoHolderWalletApiSdkTests",
            dependencies: ["MeecoHolderWalletApiSdk"]
        )
	]
)
