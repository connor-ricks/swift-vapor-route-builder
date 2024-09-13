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

@Suite("RouteModifier Tests") struct RouteModifierTests {
    @Test func test_routeModifier_whenAddedToContent_matchesExpectations() async throws {
        struct AddBModifier: RouteModifier {
            func body(content: RouteContent) -> some RouteComponent {
                Group {
                    Route.testing(name: "B")
                    content
                }
            }
        }

        try await Application.testing(content: {
            Route.testing(name: "A")
                .modifier(AddBModifier())
        }) { app in
            try await app.testing(.GET, "/A")
            try await app.testing(.GET, "/B")
            #expect(app.routes.all.count == 2)
        }

        struct AddParentModifier: RouteModifier {
            func body(content: RouteContent) -> some RouteComponent {
                Group(path: "parent") {
                    content
                }
            }
        }

        try await Application.testing(content: {
            Route.testing(name: "foo")
                .modifier(AddParentModifier())
        }) { app in
            try await app.testing(.GET, "/parent/foo")
            #expect(app.routes.all.count == 1)
        }
    }
}