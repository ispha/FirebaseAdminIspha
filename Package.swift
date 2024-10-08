// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseAdmin",
    platforms: [
        .iOS(.v15), .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "FirebaseAppIspha",
            targets: ["FirebaseAppIspha"]),
        .library(
            name: "AppCheck",
            targets: ["AppCheck"]),
        .library(
            name: "Firestore",
            targets: ["Firestore"]),
        .library(
            name: "FirebaseAuthIspha",
            targets: ["FirebaseAuthIspha"]),
        .library(
            name: "FirebaseMessagingIspha", 
            targets: ["FirebaseMessagingIspha"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.21.2"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.68.0"),
        .package(url: "https://github.com/1amageek/FirebaseAPI.git", branch: "main"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "4.13.4"),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.7")
    ],
    targets: [
        .target(
            name: "FirebaseAppIspha",
            dependencies: [
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ],
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency=targeted", .when(platforms: [.macOS, .iOS])),
                .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_FORWARD_TRAILING_CLOSURES")
            ]
        ),
        .target(
            name: "AppCheck",
            dependencies: [
                "FirebaseAppIspha",
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "JWTKit", package: "jwt-kit")
            ],
            swiftSettings: swiftSettings),
        .target(
            name: "Firestore",
            dependencies: [
                "FirebaseAppIspha",
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "FirestoreAPI", package: "FirebaseAPI"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ],swiftSettings: swiftSettings),
        .target(
            name: "FirebaseAuthIspha",
            dependencies: [
                "FirebaseAppIspha",
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "JWTKit", package: "jwt-kit"),
                .product(name: "AnyCodable", package: "AnyCodable"),
            ],swiftSettings: swiftSettings),
        .target(
            name: "FirebaseMessagingIspha",
            dependencies: [
                "FirebaseAppIspha",
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ],swiftSettings: swiftSettings),
       
    ]
)

var swiftSettings: [SwiftSetting] { [
    .enableUpcomingFeature("DisableOutwardActorInference"),
    .enableExperimentalFeature("StrictConcurrency"),
] }
