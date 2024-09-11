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

// MARK: - RouteComponent + AnyRouteComponent

extension RouteComponent {
    /// Wraps this route component with a type eraser.
    ///
    /// This form of _type erasure_ preserves abstraction across API boundaries, such as different
    /// modules.
    ///
    /// When you expose your composed route components as the ``AnyRouteComponent`` type, you can change the underlying
    /// implementation over time without affecting existing clients.
    ///
    /// Equivalent to passing `self` to `AnyRouteComponent.init`.
    ///
    /// - Returns: An ``AnyRouteComponent`` wrapping this route component.
    @inlinable
    public func eraseToAnyRouteComponent() -> AnyRouteComponent {
        AnyRouteComponent(self)
    }
}

// MARK: - AnyRouteComponent

/// A type-erased route component.
///
/// This route component forwards its ``boot(routes:)`` method to an arbitrary
/// underlying route component, hiding the specifics of the underlying route component.
///
/// Use ``AnyRouteComponent`` to wrap a route component whose type has details you don't want to expose across API
/// boundaries, such as different modules. When you use type erasure this way, you can change the
/// underlying route component over time without affecting existing clients.
public struct AnyRouteComponent: RouteComponent {

    // MARK: Properties

    @usableFromInline
    let boot: (any RoutesBuilder) throws -> Void

    // MARK: Initializers

    /// Creates a type-erasing route component to wrap the given route component.
    ///
    /// Equivalent to calling ``RouteComponent/eraseToAnyRouteComponent()`` on the route component..
    ///
    /// - Parameter component: A route component to wrap with a type eraser.
    @inlinable
    public init<C: RouteComponent>(_ component: C) {
        self.init(component.boot)
    }

    /// Creates a route component that wraps the given closure in its ``boot(routes:)`` method.
    ///
    /// - Parameter boot: A closure that attempts to boot a route component. `boot` is
    ///   executed each time the ``boot(routes:)`` method is called on the resulting route component.
    @inlinable
    public init(_ boot: @escaping (any RoutesBuilder) throws -> Void) {
        self.boot = boot
    }

    // MARK: RouteComponent

    @inlinable
    public func boot(routes: any RoutesBuilder) throws {
        try self.boot(routes)
    }

    // MARK: Helpers

    @inlinable
    public func eraseToAnyRouteComponent() -> Self {
        self
    }
}

// MARK: - RouteComponents + AnyRouteComponent

extension RouteComponents {
    public typealias AnyRouteComponent = VaporRouteBuilder.AnyRouteComponent // NB: Convenience type alias for discovery
}
