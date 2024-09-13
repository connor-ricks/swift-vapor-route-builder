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

import Testing
import Vapor
@testable import VaporRouteBuilder
import XCTVapor

@Suite("RouteComponentMiddleware Tests") struct RouteComponentMiddlewareTests {
    @Test func test_middlewareModifier_whenAttached_doesCorrectlyWrap() async throws {
        let foo = TestMiddleware(name: "foo")
        let bar = TestMiddleware(name: "bar")

        try await Application.testing(content: {
            Group(middleware: foo) {
                Route.testing(name: "A")
                    .middleware(bar)
                Route.testing(name: "B")
            }
        }) { app in
            try await app.testing(.GET, "/A", assertMiddleware: [foo, bar])
            try await app.testing(.GET, "/B", assertMiddleware: [foo])
        }
    }
}
