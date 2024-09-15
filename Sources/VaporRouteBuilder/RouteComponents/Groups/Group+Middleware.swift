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

extension Group {

    // MARK: Initializers

    /// Creates a group, nesting the provided `content` underneath the provided `middleware`.
    ///
    /// > Note: Usage of `Group(middleware:)` is internal to the framework. Attaching middleware should be accomplished
    /// by making use of the `.middleware(_:)` route modifier.
    init<C: RouteComponent>(
        middleware: any Vapor.Middleware...,
        @RouteBuilder content: () -> C
    ) where Content == Group<C>.Middleware<[any Vapor.Middleware]> {
        self.init(middleware: middleware, content: content)
    }

    /// Creates a group, nesting the provided `content` underneath the provided `middleware`.
    ///
    /// > Note: Usage of `Group(middleware:)` is internal to the framework. Attaching middleware should be accomplished
    /// by making use of the `.middleware(_:)` route modifier.
    init<C: RouteComponent, M: Collection<any Vapor.Middleware>>(
        middleware: M,
        @RouteBuilder content: () -> C
    ) where Content == Group<C>.Middleware<M> {
        self.content = Content(middleware: middleware, content: content)
    }

    // MARK: Middleware

    /// Groups content under the provided middleware.
    ///
    /// See ``Group.init(middleware:content:)`` for more info.
    struct Middleware<Middlewares: Collection<any Vapor.Middleware>>: RouteComponent {

        // MARK: Properties

        @usableFromInline
        let middleware: Middlewares

        @usableFromInline
        let content: Content

        // MARK: Initializers

        @inlinable
        init(
            middleware: any Vapor.Middleware...,
            @RouteBuilder content: () -> Content
        ) where Middlewares == [any Vapor.Middleware] {
            self.init(middleware: middleware, content: content)
        }

        @inlinable
        init(
            middleware: Middlewares,
            @RouteBuilder content: () -> Content
        ) {
            self.middleware = middleware
            self.content = content()
        }

        // MARK: Boot

        func boot(routes: any RoutesBuilder) throws {
            let routes = routes.grouped(Array(middleware))
            if let route = content as? Route {
                routes.add(route)
            } else {
                try routes.register(collection: content)
            }
        }
    }
}
