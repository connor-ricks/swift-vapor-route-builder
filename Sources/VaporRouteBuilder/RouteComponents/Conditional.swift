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

// MARK: - Conditional

/// A route component that can boot routes from two types of route components.
///
/// This route component is useful for situations where you want to boot one of two different route components
/// based on a condition, which typically would force you to perform ``RouteComponent/eraseToAnyRouteComponent`` and incur
/// a performance penalty.
///
/// You won't typically construct this route component directly, but instead will use standard `if`-`else`
/// statements in a route component builder to automatically build a conditional route component:
///
/// ```swift
/// Group {
///     if version == "2.0" {
///         NewRouteComponent()
///     } else {
///         LegacyRouteComponent()
///     }
/// }
/// ```
/// 
public enum Conditional<First: RouteComponent, Second: RouteComponent>: RouteComponent {
    case first(First)
    case second(Second)

    // MARK: Boot

    @inlinable
    public func boot(routes: any RoutesBuilder) throws {
        switch self {
        case .first(let first):
            if let route = first as? Route {
                routes.add(route)
            } else {
                try routes.register(collection: first)
            }
        case .second(let second):
            if let route = second as? Route {
                routes.add(route)
            } else {
                try routes.register(collection: second)
            }
        }
    }
}

// MARK: - RouteComponents + Conditional

extension RouteComponents {
    public typealias Conditional<First: RouteComponent, Second: RouteComponent> = VaporRouteBuilder.Conditional<First, Second> // NB: Convenience type for alias discovery.
}
