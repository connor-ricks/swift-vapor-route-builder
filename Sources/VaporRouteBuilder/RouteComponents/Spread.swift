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

import Vapor

// MARK: - Spread

/// A route component that can boot routes from a collection of provided route components.
///
/// You won't typically construct this route component directly, but instead will use standard `for`-`in`
/// loops in a route component builder to automatically build a spread route component.
///
/// ```swift
/// Group(path: "api") {
///     for i in 0..<10 {
///         IndeRouteComponent(index: i)
///     }
/// }
/// ```
///
public struct Spread<Content: Collection>: RouteComponent where Content.Element: RouteComponent {

    // MARK: Properties

    @usableFromInline
    let content: Content

    // MARK: Initializers

    @inlinable
    public init(content: Content) {
        self.content = content
    }

    // MARK: Boot

    @inlinable
    public func boot(routes: any RoutesBuilder) throws {
        for item in content {
            if let route = item as? Route {
                routes.add(route)
            } else {
                try routes.register(collection: item)
            }
        }
    }
}

// MARK: - RouteComponents + Spread

extension RouteComponents {
    public typealias Spread<C: Collection> = VaporRouteBuilder.Spread<C> where C.Element: RouteComponent
}
