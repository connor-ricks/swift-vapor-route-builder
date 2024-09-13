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

@Suite("RouteBuilder Tests") struct RouteComponentBuilderTests {
    @Test func test_resultBuilder_whenBuildBlockIsSingle_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Route.testing(name: "A")
        }) { app in
            try await app.testing(.GET, "/A")
            #expect(app.routes.all.count == 1)
        }
    }

    @Test func test_resultBuilder_whenBuildBlockIsTupleOfSameType_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Route.testing(name: "A")
            Route.testing(name: "B")
        }) { app in
            try await app.testing(.GET, "/A")
            try await app.testing(.GET, "/B")
            #expect(app.routes.all.count == 2)
        }
    }

    @Test func test_resultBuilder_whenBuildBlockIsTupleOfDifferentType_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Route.testing(name: "A")
            Group(path: "B") {
                Route.testing(name: "BB")
            }
        }) { app in
            try await app.testing(.GET, "/A")
            try await app.testing(.GET, "/B/BB")
            #expect(app.routes.all.count == 2)
        }
    }

    @Test func test_resultBuilder_whenBuildBlockIsLargeTupleOfDifferentTypes_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            Group(path: "A") {
                Route.testing(name: "AA")
                Route.testing(name: "AB")
                Route.testing(name: "AC")
            }
            Route.testing(name: "B")
            Group(path: "C") {
                Route.testing(name: "CA")
                Route.testing(name: "CB")
                Route.testing(name: "CC")
            }
            Route.testing(name: "D")
            Group(path: "E") {
                Route.testing(name: "EA")
                Route.testing(name: "EB")
                Route.testing(name: "EC")
            }
        }) { app in
            try await app.testing(.GET, "/A/AA")
            try await app.testing(.GET, "/A/AB")
            try await app.testing(.GET, "/A/AC")
            try await app.testing(.GET, "/B")
            try await app.testing(.GET, "/C/CA")
            try await app.testing(.GET, "/C/CB")
            try await app.testing(.GET, "/C/CC")
            try await app.testing(.GET, "/D")
            try await app.testing(.GET, "/E/EA")
            try await app.testing(.GET, "/E/EB")
            try await app.testing(.GET, "/E/EC")
            #expect(app.routes.all.count == 11)
        }
    }

    @Test func test_resultBuilder_whenBuildBlockIsArray_producesExpectedRoutes() async throws {
        let count = 10
        try await Application.testing(content: {
            for i in 0..<count {
                Route.testing(name: "\(i)")
            }
        }) { app in
            for i in 0..<count {
                try await app.testing(.GET, "/\(i)")
            }
            #expect(app.routes.all.count == count)
        }
    }

    @Test func test_resultBuilder_whenBuildBlockIsEitherIf_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            if true {
                Route.testing(name: "true")
            }
        }) { app in
            try await app.testing(.GET, "/true")
            #expect(app.routes.all.count == 1)
        }

        try await Application.testing(content: {
            if false {
                Route.testing(name: "false")
            }
        }) { app in
            #expect(app.routes.all.isEmpty)
        }
    }

    @Test func test_resultBuilder_whenBuildBlockIsEitherIfElse_producesExpectedRoutes() async throws {
        try await Application.testing(content: {
            if true {
                Route.testing(name: "true")
            } else {
                Route.testing(name: "false")
            }
        }) { app in
            try await app.testing(.GET, "/true")
            #expect(app.routes.all.count == 1)
        }

        try await Application.testing(content: {
            if false {
                Route.testing(name: "true")
            } else {
                Route.testing(name: "false")
            }
        }) { app in
            try await app.testing(.GET, "/false")
            #expect(app.routes.all.count == 1)
        }
    }

    // swiftlint:disable duplicate_conditions
    @Test func test_resultBuilder_whenBuildBlockIsEitherIfElseIf_producesExpectedRoutes() async throws {
        // Only 'if' path should exist.
        try await Application.testing(content: {
            if true {
                Route.testing(name: "if")
            } else if false {
                Route.testing(name: "elseIf")
            } else {
                Route.testing(name: "else")
            }
        }) { app in
            try await app.testing(.GET, "/if")
            #expect(app.routes.all.count == 1)
        }

        // Only 'else-if' path should exist.
        try await Application.testing(content: {
            if false {
                Route.testing(name: "if")
            } else if true {
                Route.testing(name: "elseIf")
            } else {
                Route.testing(name: "else")
            }
        }) { app in
            try await app.testing(.GET, "/elseIf")
            #expect(app.routes.all.count == 1)
        }

        // Only 'if' path should exist.
        try await Application.testing(content: {
            if true {
                Route.testing(name: "if")
            } else if true {
                Route.testing(name: "elseIf")
            } else {
                Route.testing(name: "else")
            }
        }) { app in
            try await app.testing(.GET, "/if")
            #expect(app.routes.all.count == 1)
        }

        // No path should exit.
        try await Application.testing(content: {
            if false {
                Route.testing(name: "if")
            } else if false {
                Route.testing(name: "elseIf")
            }
        }) { app in
            #expect(app.routes.all.isEmpty)
        }

        // Only 'else' path should exist.
        try await Application.testing(content: {
            if false {
                Route.testing(name: "if")
            } else if false {
                Route.testing(name: "elseIf")
            } else {
                Route.testing(name: "else")
            }
        }) { app in
            try await app.testing(.GET, "/else")
            #expect(app.routes.all.count == 1)
        }
    }
    // swiftlint:enable duplicate_conditions

    @Test func test_resultBuilder_whenBuildBlockIsOptionalIf_producesExpectedRoutes() async throws {
        // Only 'if' path should exist.
        try await Application.testing(content: {
            if true {
                Route.testing(name: "true")
            }
        }) { app in
            try await app.testing(.GET, "/true")
            #expect(app.routes.all.count == 1)
        }

        // No path should exist.
        try await Application.testing(content: {
            if false {
                Route.testing(name: "true")
            }
        }) { app in
            #expect(app.routes.all.isEmpty)
        }

        // Only 'if' path should exist.
        let optionalExists: Int? = 1
        try await Application.testing(content: {
            if let optionalExists {
                Route.testing(name: "\(optionalExists)")
            }
        }) { app in
            try await app.testing(.GET, "/\(1)")
            #expect(app.routes.all.count == 1)
        }

        // No path should exist.
        let optionalDoesNotExist: Int? = nil
        try await Application.testing(content: {
            if let optionalDoesNotExist {
                Route.testing(name: "\(optionalDoesNotExist)")
            }
        }) { app in
            #expect(app.routes.all.isEmpty)
        }

        // Only 'if' path should exist.
        enum Case: String { case one, two }
        let matchingCase: Case = .one
        try await Application.testing(content: {
            if case .one = matchingCase {
                Route.testing(name: "one")
            }
        }) { app in
            try await app.testing(.GET, "/one")
            #expect(app.routes.all.count == 1)
        }

        // No path should exist.
        let mismatchingCase: Case = .two
        try await Application.testing(content: {
            if case .one = mismatchingCase {
                Route.testing(name: "one")
            }
        }) { app in
            #expect(app.routes.all.isEmpty)
        }
    }

    @Test func test_resultBuilder_whenBuildBlockContainsCustomComponents_producesExpectedRoutes() async throws {
        struct UsersComponent: RouteComponent {
            var body: some RouteComponent {
                Group(path: "users") {
                    Route.testing(name: "all")
                    Group(path: ":user") {
                        Route.testing(name: "profile")
                        Route.testing(name: "favorites")
                    }
                }
            }
        }

        struct MoviesComponent: RouteComponent {
            var body: some RouteComponent {
                Group(path: "movies") {
                    Route.testing(name: "latest")
                    Route.testing(name: ":movie")
                }
            }
        }

        try await Application.testing(content: {
            UsersComponent()
            MoviesComponent()
        }) { app in
            try await app.testing(.GET, "/users/all")
            try await app.testing(.GET, "/users/tim_cook/profile")
            try await app.testing(.GET, "/users/tim_cook/favorites")
            try await app.testing(.GET, "/movies/latest")
            try await app.testing(.GET, "/movies/inception")
            #expect(app.routes.all.count == 5)
        }
    }
}
