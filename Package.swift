// swift-tools-version: 6.0
//
// MIT License
//
// Copyright (c) 2024 Connor Ricks
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import PackageDescription

let package = Package(
    name: "swift-vapor-route-builder",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .library(name: "VaporRouteBuilder", targets: ["VaporRouteBuilder"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.105.2"),
        // TODO: <Connor> This can probably be removed once Swift 6 is officially released.
        .package(url: "https://github.com/apple/swift-testing", from: "0.12.0"),
    ],
    targets: [
        .target(name: "VaporRouteBuilder", dependencies: [.product(name: "Vapor", package: "vapor")]),
        .testTarget(
            name: "VaporRouteBuilderTests",
            dependencies: [
                "VaporRouteBuilder",
                .product(name: "XCTVapor", package: "vapor"),
            ]
        ),
    ]
)

#if os(macOS) // Only add SwiftLint on supported platforms.
package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/SimplyDanny/SwiftLintPlugins", from: "0.56.2"),
])
#endif

for target in package.targets where target.type != .system {
    #if os(macOS) // Only add SwiftLint on supported platforms.
    target.plugins = target.plugins ?? []
    target.plugins?.append(contentsOf: [
        .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")
    ])
    #endif

    if case .test = target.type {
        target.dependencies.append(contentsOf: [
            // TODO: <Connor> This can probably be removed once Swift 6 is officially released.
            .product(name: "Testing", package: "swift-testing"),
        ])
    }
}
