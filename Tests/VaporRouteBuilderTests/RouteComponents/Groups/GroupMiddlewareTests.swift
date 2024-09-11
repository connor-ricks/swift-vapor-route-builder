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
import XCTVapor
@testable import VaporRouteBuilder

@Suite("Group Middleware Tests") struct GroupMiddlewareTests {
    @Test func test_variadicGroupMiddleware_withSingleMiddleware_producesExpectedRoutes() async throws {
        let foo = TestMiddleware(name: "Foo")

        try await Application.testing(content: {
            Group(middleware: foo) {
                Route.testing(name: "A")
            }
        }) { app in
            try await app.testing(.GET, "/A", assertMiddleware: [foo])
            #expect(app.routes.all.count == 1)
        }
    }

    @Test func test_variadicGroupMiddleware_withMultipleMiddlewares_producesExpectedRoutes() async throws {
        let foo = TestMiddleware(name: "Foo")
        let bar = TestMiddleware(name: "Bar")
        let baz = TestMiddleware(name: "Baz")

        try await Application.testing(content: {
            Group(middleware: foo, bar, baz) {
                Route.testing(name: "A")
            }
        }) { app in
            try await app.testing(.GET, "/A", assertMiddleware: [foo, bar, baz])
            #expect(app.routes.all.count == 1)
        }
    }

    @Test func test_variadicGroupMiddleware_withMultipleLayersOfMiddleware_producesExpectedRoutes() async throws {
        let foo = TestMiddleware(name: "Foo")
        let bar = TestMiddleware(name: "Bar")
        let baz = TestMiddleware(name: "Baz")
        let biz = TestMiddleware(name: "Biz")

        try await Application.testing(content: {
            Group(middleware: foo) {
                Route.testing(name: "A")
                Group(middleware: bar, biz) {
                    Route.testing(name: "B")
                }
            }
            Group(middleware: baz) {
                Route.testing(name: "C")
            }
        }) { app in
            try await app.testing(.GET, "/A", assertMiddleware: [foo])
            try await app.testing(.GET, "/B", assertMiddleware: [foo, bar, biz])
            try await app.testing(.GET, "/C", assertMiddleware: [baz])
            #expect(app.routes.all.count == 3)
        }
    }

    @Test func test_emptyVariadicGroupMiddleware_withWithNoRoutes_producesNoRoutes() async throws {
        let foo = TestMiddleware(name: "Foo")
        try await Application.testing(content: {
            Group(middleware: foo) {}
        }) { app in
            #expect(app.routes.all.count == 0)
        }
    }

    @Test func test_collectionGroupMiddleware_withSingleMiddleware_producesExpectedRoutes() async throws {
        let foo = TestMiddleware(name: "Foo")

        try await Application.testing(content: {
            Group(middleware: [foo]) {
                Route.testing(name: "A")
            }
        }) { app in
            try await app.testing(.GET, "/A", assertMiddleware: [foo])
            #expect(app.routes.all.count == 1)
        }
    }

    @Test func test_collectionGroupMiddleware_withMultipleMiddlewares_producesExpectedRoutes() async throws {
        let foo = TestMiddleware(name: "Foo")
        let bar = TestMiddleware(name: "Bar")
        let baz = TestMiddleware(name: "Baz")

        try await Application.testing(content: {
            Group(middleware: [foo, bar, baz]) {
                Route.testing(name: "A")
            }
        }) { app in
            try await app.testing(.GET, "/A", assertMiddleware: [foo, bar, baz])
            #expect(app.routes.all.count == 1)
        }
    }

    @Test func test_collectionGroupMiddleware_withMultipleLayersOfMiddleware_producesExpectedRoutes() async throws {
        let foo = TestMiddleware(name: "Foo")
        let bar = TestMiddleware(name: "Bar")
        let baz = TestMiddleware(name: "Baz")
        let biz = TestMiddleware(name: "Biz")

        try await Application.testing(content: {
            Group(middleware: [foo]) {
                Route.testing(name: "A")
                Group(middleware: [bar, biz]) {
                    Route.testing(name: "B")
                }
            }
            Group(middleware: [baz]) {
                Route.testing(name: "C")
            }
        }) { app in
            try await app.testing(.GET, "/A", assertMiddleware: [foo])
            try await app.testing(.GET, "/B", assertMiddleware: [foo, bar, biz])
            try await app.testing(.GET, "/C", assertMiddleware: [baz])
            #expect(app.routes.all.count == 3)
        }
    }

    @Test func test_emptyCollectionGroupMiddleware_withWithNoRoutes_producesNoRoutes() async throws {
        let foo = TestMiddleware(name: "Foo")
        try await Application.testing(content: {
            Group(middleware: [foo]) {}
        }) { app in
            #expect(app.routes.all.count == 0)
        }
    }
}
