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

import Vapor

extension Group {

    // MARK: Initializers

    /// Creates a group, nesting the provided `content` underneath the provided `path`.
    ///
    /// This can be useful when you have a series of endpoints that all exist under a given parent path.
    /// For example, take an api that serves up content about books and movies. You might have the following endpoints...
    ///
    /// - `/movies/latest`
    /// - `/movies/upcoming`
    /// - `/books/latest`
    /// - `/books/upcoming`
    ///
    /// ```swift
    /// Group("movies") {
    ///     Route("latest", on .GET) { ... }
    ///     Route("upcoming", on .GET) { ... }
    /// }
    /// Group("books") {
    ///     Route("latest", on .GET) { ... }
    ///     Route("upcoming", on .GET) { ... }
    /// }
    /// ```
    ///
    @inlinable
    public init<C: RouteComponent>(
        _ path: PathComponent...,
        @RouteBuilder content: () -> C
    ) where Content == Group<C>.Path<[PathComponent]> {
        self.init(path, content: content)
    }

    /// Creates a group, nesting the provided `content` underneath the provided `path`.
    ///
    /// This can be useful when you have a series of endpoints that all exist under a given parent path.
    /// For example, take an api that serves up content about books and movies. You might have the following endpoints...
    ///
    /// - `/movies/latest`
    /// - `/movies/upcoming`
    /// - `/books/latest`
    /// - `/books/upcoming`
    ///
    /// ```swift
    /// Group("movies") {
    ///     Route("latest", on .GET) { ... }
    ///     Route("upcoming", on .GET) { ... }
    /// }
    /// Group("books") {
    ///     Route("latest", on .GET) { ... }
    ///     Route("upcoming", on .GET) { ... }
    /// }
    /// ```
    ///
    @inlinable
    public init<C: RouteComponent, P: Collection<PathComponent>>(
        _ path: P,
        @RouteBuilder content: () -> C
    ) where Content == Group<C>.Path<P> {
        self.content = Content(path: path, content: content)
    }

    // MARK: Path

    /// Groups content under a provided path.
    ///
    /// See ``Group.init(path:content:)`` for more info.
    public struct Path<Path: Collection<PathComponent>>: RouteComponent {

        // MARK: Properties

        @usableFromInline
        let path: Path

        @usableFromInline
        let content: Content

        // MARK: Initializers

        @inlinable
        public init(
            path: PathComponent...,
            @RouteBuilder content: () -> Content
        ) where Path == [PathComponent] {
            self.init(path: path, content: content)
        }

        @inlinable
        public init(
            path: Path,
            @RouteBuilder content: () -> Content
        ) {
            self.path = path
            self.content = content()
        }

        // MARK: Boot

        @inlinable
        public func boot(routes: any RoutesBuilder) throws {
            let routes = path.isEmpty ? routes : routes.grouped(Array(path))
            if let route = content as? Route {
                routes.add(route)
            } else {
                try routes.register(collection: content)
            }
        }
    }
}
