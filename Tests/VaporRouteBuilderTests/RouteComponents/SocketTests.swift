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

@Suite("Socket Tests") struct SocketTests {
    @Test func test_webSocketClient() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try app.register {
            Socket("foo") { _, ws in
                ws.send("foo")
                ws.close(promise: nil)
            }
        }

        app.environment.arguments = ["serve"]
        app.http.server.configuration.port = 0

        try app.start()

        XCTAssertNotNil(app.http.server.shared.localAddress)
        guard
            let localAddress = app.http.server.shared.localAddress,
            let port = localAddress.port
        else {
            XCTFail("couldn't get ip/port from \(app.http.server.shared.localAddress.debugDescription)")
            return
        }

        let promise = app.eventLoopGroup.next().makePromise(of: String.self)
        WebSocket.connect(
            to: "ws://localhost:\(port)/foo",
            on: app.eventLoopGroup.next()
        ) { ws in
            // do nothing
            ws.onText { _, string in
                promise.succeed(string)
            }
        }.cascadeFailure(to: promise)

        try XCTAssertEqual(promise.futureResult.wait(), "foo")
    }
}
