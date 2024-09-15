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

@Suite("Tuple Tests") struct TupleTests {
    @Test func test_tuple_withOneComponent_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Tuple(content: Route.testing(name: "A"))
        }) { app in
            try await app.testing(.GET, "/A")
            #expect(app.routes.all.count == 1)
        }
    }

    @Test func test_tuple_withMultipleComponents_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Tuple(content: (
                Route.testing(name: "A"),
                Route.testing(name: "B")
            ))
        }) { app in
            try await app.testing(.GET, "/A")
            try await app.testing(.GET, "/B")
            #expect(app.routes.all.count == 2)
        }
    }

    @Test func test_tuple_withMultipleDifferentComponents_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Tuple(content: (
                Route.testing(name: "A"),
                Group("B") {
                    Route.testing(name: "BB")
                },
                Route.testing(name: "C")
            ))
        }) { app in
            try await app.testing(.GET, "/A")
            try await app.testing(.GET, "/B/BB")
            try await app.testing(.GET, "/C")
            #expect(app.routes.all.count == 3)
        }
    }
}
