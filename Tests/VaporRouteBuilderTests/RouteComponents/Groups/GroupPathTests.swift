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

@Suite("Group Path Tests") struct GroupPathTests {
    @Test func test_variadicGroupPath_withSinglePath_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Group("A") {
                Route.testing(name: "B")
            }
        }) { app in
            try await app.testing(.GET, "/A/B")
            #expect(app.routes.all.count == 1)
        }
    }

    @Test func test_variadicGroupPath_withMultiplePaths_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Group("A", "B", "C") {
                Route.testing(name: "D")
                Route.testing(name: "DD")
            }
        }) { app in
            try await app.testing(.GET, "/A/B/C/D")
            try await app.testing(.GET, "/A/B/C/DD")
            #expect(app.routes.all.count == 2)
        }
    }

    @Test func test_emptyVariadicGroupPath_withWithNoRoutes_producesNoRoutes() async throws {
        try await Application.testing(content: {
            Group(["A", "B", "C"]) {}
        }) { app in
            #expect(app.routes.all.isEmpty)
        }
    }

    @Test func test_collectionGroupPath_withSinglePath_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Group(["A"]) {
                Route.testing(name: "B")
            }
        }) { app in
            try await app.testing(.GET, "/A/B")
            #expect(app.routes.all.count == 1)
        }
    }

    @Test func test_collectionGroupPath_withMultiplePaths_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Group(["A", "B", "C"]) {
                Route.testing(name: "D")
                Route.testing(name: "DD")
            }
        }) { app in
            try await app.testing(.GET, "/A/B/C/D")
            try await app.testing(.GET, "/A/B/C/DD")
            #expect(app.routes.all.count == 2)
        }
    }

    @Test func test_emptyCollectionGroupPath_withWithNoRoutes_producesNoRoutes() async throws {
        try await Application.testing(content: {
            Group(["A", "B", "C"]) {}
        }) { app in
            #expect(app.routes.all.isEmpty)
        }
    }
}
