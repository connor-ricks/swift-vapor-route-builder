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

@Suite("AnyRouteComponent Tests") struct AnyRouteComponentTests {
    @Test func test_anyRouteComponent_withSimpleComponent_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Route.testing(name: "A").eraseToAnyRouteComponent()
        }) { app in
            try await app.testing(.GET, "/A")
            #expect(app.routes.all.count == 1)
        }
    }

    @Test func test_anyRouteComponent_withComplexComponent_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Group("users") {
                Group(":user") {
                    Route.testing(name: "profile").eraseToAnyRouteComponent()
                    Route.testing(name: "settings").eraseToAnyRouteComponent()
                }

                Route.testing(name: "online")
                Route.testing(name: "top")
            }.eraseToAnyRouteComponent()
        }) { app in
            try await app.testing(.GET, "/users/1/profile")
            try await app.testing(.GET, "/users/2/settings")
            try await app.testing(.GET, "/users/online")
            try await app.testing(.GET, "/users/top")
            #expect(app.routes.all.count == 4)
        }
    }
}
