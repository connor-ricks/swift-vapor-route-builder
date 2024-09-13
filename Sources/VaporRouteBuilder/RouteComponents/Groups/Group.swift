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

// MARK: - Group

/// A route component that allows you to group route components together.
///
/// A `Group` can be used to nest route components under a given path of a vapor application.
/// You can use `Group` to help organize and structure a complex api containing many sub-routes.
///
/// ```swift
/// Group(path: "api") {
///     Route("users", on .GET) { ... }
///     Route("articles", on .GET) { ... }
///     Route("latest", on .GET) { ... }
/// }
/// ```
///
/// In the above example, three routes are created.
/// - `api/users`
/// - `api/articles`
/// - `api/latest`
///
/// In addition to grouping by path, you can also use `Group` to wrap a set of route components
/// behind middleware. This is helpful when you have groups of routes that you may want to wrap
/// with a particular middleware, such as authentication, while leaving other routes untouched.
///
/// ```swift
/// Group(middleware: AuthenticationMiddleware()) {
///     Route("profile", on .GET) { ... }
///     Route("favorites", on .GET) { ... }
/// }
/// Route("upcoming", on .GET) { ... }
/// Route("live", on .GET) { ... }
/// ```
///
/// In the above example, the routes for `/profile` and `/favorites` will both trigger the `AuthenticationMiddleware`
/// while the routes for `/upcoming` and `/live` will not.
///
public struct Group<Content: RouteComponent>: RouteComponent {

    // MARK: Properties

    @usableFromInline
    let content: Content

    // MARK: Path Initializers

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
    /// Group(path: "movies") {
    ///     Route("latest", on .GET) { ... }
    ///     Route("upcoming", on .GET) { ... }
    /// }
    /// Group(path: "books") {
    ///     Route("latest", on .GET) { ... }
    ///     Route("upcoming", on .GET) { ... }
    /// }
    /// ```
    ///
    @inlinable
    public init<C: RouteComponent>(
        path: PathComponent...,
        @RouteBuilder content: () -> C
    ) where Content == Group<C>.Path<[PathComponent]> {
        self.init(path: path, content: content)
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
    /// Group(path: "movies") {
    ///     Route("latest", on .GET) { ... }
    ///     Route("upcoming", on .GET) { ... }
    /// }
    /// Group(path: "books") {
    ///     Route("latest", on .GET) { ... }
    ///     Route("upcoming", on .GET) { ... }
    /// }
    /// ```
    ///
    @inlinable
    public init<C: RouteComponent, P: Collection<PathComponent>>(
        path: P,
        @RouteBuilder content: () -> C
    ) where Content == Group<C>.Path<P> {
        self.content = Content(path: path, content: content)
    }

    // MARK: Middleware Initializers

    /// Creates a group, nested the provided `content` underneath the provided `middleware`.
    ///
    /// This can be useful when you want to wrap a series of endpoints behind middleware, such as authentication,
    /// while leaving other routes untouched.
    ///
    /// ```swift
    /// Group(middleware: AuthenticationMiddleware()) {
    ///     Route("profile", on .GET) { ... }
    ///     Route("favorites", on .GET) { ... }
    /// }
    /// Route("upcoming", on .GET) { ... }
    /// Route("live", on .GET) { ... }
    /// ```
    ///
    @inlinable
    public init<C: RouteComponent>(
        middleware: any Vapor.Middleware...,
        @RouteBuilder content: () -> C
    ) where Content == Group<C>.Middleware<[any Vapor.Middleware]> {
        self.init(middleware: middleware, content: content)
    }

    /// Creates a group, nested the provided `content` underneath the provided `middleware`.
    ///
    /// This can be useful when you want to wrap a series of endpoints behind middleware, such as authentication,
    /// while leaving other routes untouched.
    ///
    /// ```swift
    /// Group(middleware: AuthenticationMiddleware()) {
    ///     Route("profile", on .GET) { ... }
    ///     Route("favorites", on .GET) { ... }
    /// }
    /// Route("upcoming", on .GET) { ... }
    /// Route("live", on .GET) { ... }
    /// ```
    ///
    @inlinable
    public init<C: RouteComponent, M: Collection<any Vapor.Middleware>>(
        middleware: M,
        @RouteBuilder content: () -> C
    ) where Content == Group<C>.Middleware<M> {
        self.content = Content(middleware: middleware, content: content)
    }

    // MARK: Spread Initializers

    /// Creates an organizational group around the provided `content`. Unlike creating a group with a `path` or `middleware`
    /// this group is purely used for organizatinal purposes. When the `content` is booted, it will be booted directly
    /// to this `Group`'s parent
    ///
    /// ```swift
    /// Group {
    ///     Group {
    ///         Route("profile", on .GET) { ... }
    ///         Route("favorites", on .GET) { ... }
    ///     }
    ///     Route("latest", on .GET) { ... }
    /// }
    /// ```
    ///
    /// The above example would result in three endpoints...
    /// - `/profile`
    /// - `/favorites`
    /// - `/latest`
    ///
    @inlinable
    public init(
        @RouteBuilder content: () -> Content
    ) {
        self.content = content()
    }

    // MARK: Boot

    @inlinable
    public func boot(routes: any RoutesBuilder) throws {
        try content.boot(routes: routes)
    }
}

// MARK: - RouteComponents + Group

extension RouteComponents {
    public typealias Group<C: RouteComponent> = VaporRouteBuilder.Group<C> // NB: Convenience type for alias discovery.
}
