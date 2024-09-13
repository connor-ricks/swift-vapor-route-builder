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

@Suite("Conditional Tests") struct ConditionalTests {
    @Test func test_conditional_whenFirst_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Conditional<Route, Group<Route>>.first(Route.testing(name: "first"))
        }) { app in
            try await app.testing(.GET, "/first")
            #expect(app.routes.all.count == 1)
        }
    }

    @Test func test_conditional_whenSecond_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Conditional<Route, Group<Route>>.second(Group(content: { Route.testing(name: "second") }))
        }) { app in
            try await app.testing(.GET, "/second")
            #expect(app.routes.all.count == 1)
        }
    }
}
