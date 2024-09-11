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

// MARK: - Array + RouteComponent

extension Array: RouteComponent where Element: RouteComponent {
    @inlinable
    public var body: some RouteComponent {
        Spread(content: self)
    }
}

// MARK: - Array + RouteCollection

extension Array: @retroactive RouteCollection where Element: RouteComponent {
    @inlinable
    public func boot(routes: any RoutesBuilder) throws {
        try body.boot(routes: routes)
    }
}

// MARK: - RouteComponents + Array

extension RouteComponents {
    public typealias Array = Swift.Array // NB: Convenience type alias for discovery
}
