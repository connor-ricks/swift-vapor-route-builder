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

/// Declares a type that can be used to represent the routes in a `Vapor` application.
///
/// You can attach the contents of a route components body to a `Vapor` application by calling `RouteComponent.boot(routes:)`
/// Route components allow you to define the routes of a `Vapor` api using a declarative syntax laguage.
public protocol RouteComponent: RouteCollection {
    /// NB: For Xcode to favor autocompleting `var body: Body` over `var body: Never` we must use a type alias.
    associatedtype _Body

    /// A type representing the body of this component.
    typealias Body = _Body

    /// The content and behavior of a route component that is composed from other route components.
    ///
    /// Implement this requirement when you want to incorporate the behavior of other
    /// route components together.
    ///
    /// > Warning: Do not invoke this property directly.
    @RouteBuilder
    var body: Body { get }
}

// MARK: - RouteComponent + Body (Never)

extension RouteComponent where Body == Never {
    /// A non-existent body.
    ///
    /// > Warning: Do not invoke this property directly. It will trigger a fatal error at runtime.
    @_transparent
    public var body: Body {
        fatalError("""
        '\(Self.self)' has no body.

        Do not access a route component's 'body' property directly, as it may not exist. To use a route component,
        call 'RouteComponent.boot(routes:)', instead.
        """)
    }
}

// MARK: - RouteComponent + Body (RouteComponent)

extension RouteComponent where Body: RouteComponent {
    @inlinable
    @inline(__always)
    public func boot(routes: any RoutesBuilder) throws {
        try routes.register(collection: body)
    }
}
