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

// MARK: - PATCH

/// A convenience route component that wraps `Route`.
///
/// This component creates a `Route` for the HTTP method `PATCH`.
public struct PATCH: RouteComponent {

    // MARK: Properties

    @usableFromInline
    let route: Route

    // MARK: Initializers

    /// Creates a `Route` with the `PATCH` HTTP Method at the provided path.
    ///
    /// - Parameters:
    ///   - path: The path of the route.
    ///   - strategy: The body streaming strategy.
    ///   - use: The closure handler for incoming requests.
    @inlinable
    public init<Path: Collection, Response: ResponseEncodable>(
        _ path: Path,
        strategy: HTTPBodyStreamStrategy = .collect,
        use: @Sendable @escaping (Request) throws -> Response
    ) where Path.Element == PathComponent {
        self.route = Route(.PATCH, path, body: strategy, use: use)
    }

    /// Creates a `Route` with the `PATCH` HTTP Method at the provided path.
    ///
    /// - Parameters:
    ///   - path: The path of the route.
    ///   - strategy: The body streaming strategy.
    ///   - use: The closure handler for incoming requests.
    @inlinable
    public init<Path: Collection, Response: AsyncResponseEncodable>(
        _ path: Path,
        strategy: HTTPBodyStreamStrategy = .collect,
        use: @Sendable @escaping (Request) async throws -> Response
    ) where Path.Element == PathComponent {
        self.route = Route(.PATCH, path, body: strategy, use: use)
    }

    /// Creates a `Route` with the `PATCH` HTTP Method at the provided path.
    ///
    /// - Parameters:
    ///   - path: The path of the route.
    ///   - strategy: The body streaming strategy.
    ///   - use: The closure handler for incoming requests.
    @inlinable
    public init<Response: ResponseEncodable>(
        _ path: PathComponent...,
        strategy: HTTPBodyStreamStrategy = .collect,
        use: @Sendable @escaping (Request) throws -> Response
    ) {
        self.route = Route(.PATCH, path, body: strategy, use: use)
    }

    /// Creates a `Route` with the `PATCH` HTTP Method at the provided path.
    ///
    /// - Parameters:
    ///   - path: The path of the route.
    ///   - strategy: The body streaming strategy.
    ///   - use: The closure handler for incoming requests.
    @inlinable
    public init<Response: AsyncResponseEncodable>(
        _ path: PathComponent...,
        strategy: HTTPBodyStreamStrategy = .collect,
        use: @Sendable @escaping (Request) async throws -> Response
    ) {
        self.route = Route(.PATCH, path, body: strategy, use: use)
    }

    // MARK: Body

    public var body: some RouteComponent {
        route
    }
}

// MARK: - RouteComponents + PATCH

extension RouteComponents {
    public typealias PATCH = VaporRouteBuilder.PATCH // NB: Convenience type alias for discovery
}
