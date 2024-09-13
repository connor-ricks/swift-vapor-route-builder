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

// MARK: - RouteModifier

/// A modifier that you apply to a route component or another route modifier, producing a different version of the original value.
///
/// Adopt the `RouteModifier` protocol when you want to create a reusable modifier that you can apply to any route component.
public protocol RouteModifier<Body> {
    associatedtype Body: RouteComponent

    @RouteBuilder
    func body(content: RouteContent) -> Body

    typealias RouteContent = RouteModifierContent<Self>
}

// MARK: - RouteModifierContent

public struct RouteModifierContent<Value>: RouteComponent {

    // MARK: Properties

    @usableFromInline
    let content: AnyRouteComponent

    // MARK: Initializers

    @inlinable
    init(_ content: some RouteComponent) {
        self.content = AnyRouteComponent(content)
    }

    // MARK: Body

    public var body: some RouteComponent {
        content
    }
}

// MARK: - RouteComponent + Modifier

extension RouteComponent {
    /// Applies a modifier to a route component and returns a new route component.
    @inlinable
    public func modifier<Modifier: RouteModifier>(_ modifier: Modifier) -> some RouteComponent {
        modifier.body(content: RouteModifierContent(self))
    }
}
