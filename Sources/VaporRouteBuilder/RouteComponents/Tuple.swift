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

// MARK: - Tuple

/// A route component that can boot routes from any number of arbitrary route components.
///
/// This route component is useful for situations where you want to boot an arbitrary number of
/// route components of varying types, which typically would force you to perform ``RouteComponent/eraseToAnyRouteComponent()`` and incur
/// a performance penalty.
///
/// You won't typically construct this route component directly, but instead will compose route components
/// in a route component builder to automatically build a tuple route component.
///
/// ```swift
/// Group {
///     Group(path: "authenticated") {
///         Group(middleware: AuthenticatedMiddleware()) {
///             ProfileRoute()
///             SettingsRoute()
///         }
///         LoginRoute()
///         ForgotPasswordRoute()
///         ResetPasswordRoute()
///     }
///     LatestRoute()
///     UpcomingRoute()
/// }
/// ```
/// 
public struct Tuple<each Content: RouteComponent>: RouteComponent {

    // MARK: Properties

    @usableFromInline
    let content: (repeat each Content)

    // MARK: Initializers

    @inlinable
    public init(content: (repeat each Content)) {
        self.content = content
    }

    // MARK: Boot

    @inlinable
    public func boot(routes: any RoutesBuilder) throws {
        for item in repeat each content {
            if let route = item as? Route {
                routes.add(route)
            } else {
                try routes.register(collection: item)
            }
        }
    }
}

// MARK: - RouteComponents + Tuple

extension RouteComponents {
    public typealias Tuple<each C: RouteComponent> = VaporRouteBuilder.Tuple<repeat each C>
}
