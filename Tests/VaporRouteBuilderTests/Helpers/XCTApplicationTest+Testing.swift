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
import XCTVapor

// MARK: - XCTApplicationTester + Testing

extension XCTApplicationTester {
    @discardableResult
    func testing(
        _ method: HTTPMethod,
        _ path: String,
        headers: HTTPHeaders = [:],
        body: ByteBuffer? = nil,
        fileId: String = #fileID,
        filePath: StaticString = #filePath,
        line: Int = #line,
        column: Int = #column,
        assertMiddleware middleware: [TestMiddleware] = [],
        beforeRequest: @escaping (inout XCTHTTPRequest) async throws -> Void = { _ in }
    ) async throws -> XCTApplicationTester {
        func test() async throws -> XCTApplicationTester {
            try await self.test(
                method,
                path,
                headers: headers,
                body: body,
                file: filePath,
                line: UInt(line),
                beforeRequest: beforeRequest,
                afterResponse: { res async in
                    #expect(
                        path == res.body.string,
                        sourceLocation: SourceLocation(
                            fileID: fileId,
                            filePath: "\(filePath)",
                            line: line,
                            column: column
                        )
                    )
                }
            )
        }

        let expected = middleware
        var executed = [TestMiddleware]()

        func test(expected: inout [TestMiddleware]) async throws -> XCTApplicationTester {
            guard !expected.isEmpty else {
                return try await test()
            }

            let next = expected.removeFirst()
            return try await confirmation("Expected middleware: \(next.name) to execute.", expectedCount: 1) { didFire in
                next.block = {
                    executed.append(next)
                    didFire()
                }

                return try await test(expected: &expected)
            }
        }

        func compare(executed: [TestMiddleware], expected: [TestMiddleware]) {
            let executed = executed.map(\.name)
            let expected = expected.map(\.name)
            #expect(
                executed == expected,
                """

                Executed middleware did not match expectations.

                Expected: \(expected.joined(separator: ", "))
                Executed: \(executed.joined(separator: ", "))
                """,
                sourceLocation: SourceLocation(
                    fileID: fileId,
                    filePath: "\(filePath)",
                    line: line,
                    column: column
                )
            )
        }

        var copyOfExpected = expected
        let app = try await test(expected: &copyOfExpected)
        compare(executed: executed, expected: expected)
        return app
    }
}

// MARK: - TestMiddleware

final class TestMiddleware: Middleware, @unchecked Sendable {

    // MARK: Properties

    let name: String
    let fileId: String
    let filePath: String
    let line: Int
    let column: Int

    fileprivate lazy var block: () -> Void = {
        Issue.record(
            "TestMiddleware was created and executed but not asserted on.",
            sourceLocation: SourceLocation(
                fileID: self.fileId,
                filePath: self.filePath,
                line: self.line,
                column: self.column
            )
        )
    }

    // MARK: Initializers

    init(
        name: String,
        fileId: String = #fileID,
        filePath: String = #filePath,
        line: Int = #line,
        column: Int = #column
    ) {
        self.name = name
        self.fileId = fileId
        self.filePath = filePath
        self.line = line
        self.column = column
    }

    // MARK: Middleware

    nonisolated func respond(to request: Request, chainingTo next: Responder) -> EventLoopFuture<Response> {
        block()
        return next.respond(to: request)
    }
}
