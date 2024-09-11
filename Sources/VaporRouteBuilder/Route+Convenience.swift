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

extension Route {

    /// Creates a route handling the request with a closure.
    @inlinable
    public convenience init<Path: Collection, Response: ResponseEncodable>(
        _ method: HTTPMethod,
        _ path: Path,
        body: HTTPBodyStreamStrategy = .collect,
        use closure: @Sendable @escaping (Request) throws -> Response
    ) where Path.Element == PathComponent {
        let responder = BasicResponder { request in
            if case .collect(let max) = body, request.body.data == nil {
                return request.body.collect(
                    max: max?.value ?? request.application.routes.defaultMaxBodySize.value
                ).flatMapThrowing { _ in
                    try closure(request)
                }.encodeResponse(for: request)
            } else {
                return try closure(request)
                    .encodeResponse(for: request)
            }
        }

        self.init(method: method, path: Array(path), responder: responder, requestType: Request.self, responseType: Response.self)
    }

    /// Creates a route handling the request with an async closure.
    @inlinable
    public convenience init<Path: Collection, Response: AsyncResponseEncodable>(
        _ method: HTTPMethod,
        _ path: Path,
        body: HTTPBodyStreamStrategy = .collect,
        use closure: @Sendable @escaping (Request) async throws -> Response
    ) where Path.Element == PathComponent {
        let responder = AsyncBasicResponder { request in
            if case .collect(let max) = body, request.body.data == nil {
                _ = try await request.eventLoop.flatSubmit {
                    request.body.collect(max: max?.value ?? request.application.routes.defaultMaxBodySize.value)
                }.get()

            }
            return try await closure(request).encodeResponse(for: request)
        }

        self.init(method: method, path: Array(path), responder: responder, requestType: Request.self, responseType: Response.self)
    }

    /// Creates a route handling the request with a closure.
    @inlinable
    public convenience init<Response: ResponseEncodable>(
        _ method: HTTPMethod,
        _ path: PathComponent...,
        body: HTTPBodyStreamStrategy = .collect,
        use closure: @Sendable @escaping (Request) throws -> Response
    ) {
        self.init(method, path, body: body, use: closure)
    }

    /// Creates a route handling the request with an async closure.
    @inlinable
    public convenience init<Response: AsyncResponseEncodable>(
        _ method: HTTPMethod,
        _ path: PathComponent...,
        body: HTTPBodyStreamStrategy = .collect,
        use closure: @Sendable @escaping (Request) async throws -> Response
    ) {
        self.init(method, path, body: body, use: closure)
    }
}
