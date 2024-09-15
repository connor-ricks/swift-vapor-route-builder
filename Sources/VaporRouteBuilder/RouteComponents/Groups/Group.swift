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
/// Group("api") {
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
/// In addition to grouping by path, you can also use `Group` to wrap a set of route components, allowing
/// you to apply modifiers to all the nested children. This is helpful when you have groups of routes that you may want to wrap
/// with a particular modifier, such as authentication middleware.
///
/// ```swift
/// Group {
///     Group {
///         Route("profile", on .GET) { ... }
///         Route("favorites", on .GET) { ... }
///     }
///     .middleware(AuthenticationMiddleware())
///     Route("upcoming", on .GET) { ... }
///     Route("live", on .GET) { ... }
/// }
/// .middleware(ValidationMiddleware())
/// ```
///
/// In the above example, the routes for `/profile` and `/favorites` will both trigger the `ValidationMiddleware` and `AuthenticationMiddleware`
/// while the routes for `/upcoming` and `/live` will only trigger the `ValidationMiddleware`.
///
public struct Group<Content: RouteComponent>: RouteComponent {

    // MARK: Properties

    @usableFromInline
    let content: Content

    // MARK: Initializers

    /// Creates an organizational group around the provided `content`.
    /// You can use this group to apply modifiers to all the nested components. When `content` is booted, it will be booted directly
    /// to this `Group`'s parent
    ///
    /// ```swift
    /// Group {
    ///     Route("profile", on .GET) { ... }
    ///     Route("favorites", on .GET) { ... }
    /// }
    /// .middleware(AuthenticationMiddleware())
    /// ```
    ///
    @inlinable
    public init(@RouteBuilder content: () -> Content) {
        self.content = content()
    }

    // MARK: Body

    public var body: some RouteComponent {
        content
    }
}

// MARK: - RouteComponents + Group

extension RouteComponents {
    public typealias Group<C: RouteComponent> = VaporRouteBuilder.Group<C> // NB: Convenience type for alias discovery.
}
