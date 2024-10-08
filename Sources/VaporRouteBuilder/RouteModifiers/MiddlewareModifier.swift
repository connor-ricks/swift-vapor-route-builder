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

import Vapor

// MARK: - MiddlewareModifier

/// A route modifier that wraps its content in the provided middleware.
private struct MiddlewareModifier<Middlewares: Collection<any Vapor.Middleware>>: RouteModifier {

    // MARK: Properties

    /// The middleware to add to the content.
    let middleware: Middlewares

    // MARK: Body

    func body(content: RouteContent) -> some RouteComponent {
        Group(middleware: middleware) {
            content
        }
    }
}

// MARK: - RouteComponent + Middleware

extension RouteComponent {
    /// Modifies the route component by wrapping it in the provided `Middleware`.
    public func middleware(_ middleware: any Middleware...) -> some RouteComponent {
        modifier(MiddlewareModifier(middleware: middleware))
    }

    /// Modifies the route component by wrapping it in the provided `Middleware`.
    public func middleware<C: Collection<any Middleware>>(_ middleware: C) -> some RouteComponent {
        modifier(MiddlewareModifier(middleware: middleware))
    }
}
