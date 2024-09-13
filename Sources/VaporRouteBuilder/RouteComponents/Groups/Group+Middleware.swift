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
    /// Groups content under the provided middleware.
    ///
    /// See ``Group.init(middleware:content:)`` for more info.
    public struct Middleware<Middlewares: Collection<any Vapor.Middleware>>: RouteComponent {

        // MARK: Properties

        @usableFromInline
        let middleware: Middlewares

        @usableFromInline
        let content: Content

        // MARK: Initializers

        @inlinable
        public init(
            middleware: any Vapor.Middleware...,
            @RouteBuilder content: () -> Content
        ) where Middlewares == [any Vapor.Middleware] {
            self.middleware = middleware
            self.content = content()
        }

        @inlinable
        public init(
            middleware: Middlewares,
            @RouteBuilder content: () -> Content
        ) {
            self.middleware = middleware
            self.content = content()
        }

        // MARK: Boot

        public func boot(routes: any RoutesBuilder) throws {
            let routes = routes.grouped(Array(middleware))
            if let route = content as? Route {
                routes.add(route)
            } else {
                try routes.register(collection: content)
            }
        }
    }
}
