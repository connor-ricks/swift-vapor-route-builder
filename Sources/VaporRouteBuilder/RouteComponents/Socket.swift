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

// MARK: - Socket

public struct Socket: RouteComponent {

    // MARK: Properties

    @usableFromInline
    let route: Route

    // MARK: Initializers

    @inlinable
    public init(
        _ path: PathComponent...,
        maxFrameSize: WebSocketMaxFrameSize = .default,
        shouldUpgrade: @escaping (@Sendable (Request) async throws -> HTTPHeaders?) = { _ in [:] },
        onUpgrade: @Sendable @escaping (Request, WebSocket) async -> Void
    ) {
        self.init(path, maxFrameSize: maxFrameSize, shouldUpgrade: shouldUpgrade, onUpgrade: onUpgrade)
    }

    @inlinable
    public init<Path: Collection>(
        _ path: Path,
        maxFrameSize: WebSocketMaxFrameSize = .default,
        shouldUpgrade: @escaping (@Sendable (Request) async throws -> HTTPHeaders?) = { _ in [:] },
        onUpgrade: @Sendable @escaping (Request, WebSocket) async -> Void
    ) where Path.Element == PathComponent {
        self.route = Route(.GET, path) { request -> Response in
            request.webSocket(maxFrameSize: maxFrameSize, shouldUpgrade: shouldUpgrade, onUpgrade: onUpgrade)
        }
    }

    // MARK: Body

    public var body: some RouteComponent {
        route
    }
}
