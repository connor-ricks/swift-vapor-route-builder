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

@Suite("Route Tests") struct RouteTests {
    @Test func test_route_producesExpectedRoute() async throws {
        try await Application.testing(content: {
            Route.testing(name: "A")
        }) { app in
            try await app.testing(.GET, "/A")
            #expect(app.routes.all.count == 1)
        }
    }

    @Test func test_route_asChildOfGroupWithoutPath_producesRouteMatchingParent() async throws {
        try await Application.testing(content: {
            Group("A") {
                DELETE { _ in "delete" }
                GET { _ in "get" }
                PATCH { _ in "patch" }
                POST { _ in "post" }
                PUT { _ in "put" }
                Route(.OPTIONS) { _ in "options" }
            }
        }) { app in
            try await app.testing(.DELETE, "/A", afterResponse: { res in
                #expect(res.body.string == "delete")
            })

            try await app.testing(.GET, "/A", afterResponse: { res in
                #expect(res.body.string == "get")
            })

            try await app.testing(.PATCH, "/A", afterResponse: { res in
                #expect(res.body.string == "patch")
            })

            try await app.testing(.POST, "/A", afterResponse: { res in
                #expect(res.body.string == "post")
            })

            try await app.testing(.PUT, "/A", afterResponse: { res in
                #expect(res.body.string == "put")
            })

            try await app.testing(.OPTIONS, "/A", afterResponse: { res in
                #expect(res.body.string == "options")
            })

            #expect(app.routes.all.count == 6)
        }
    }
}
