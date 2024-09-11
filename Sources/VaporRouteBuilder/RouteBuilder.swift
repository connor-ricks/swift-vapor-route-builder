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

@resultBuilder
public enum RouteBuilder {

    // MARK: buildBlock (Single)

    @inlinable
    public static func buildBlock<C: RouteComponent>(_ content: C) -> C {
        content
    }

    // MARK: buildblock (Tuple)

    @inlinable
    public static func buildBlock<each C>(_ content: repeat each C) -> Tuple<repeat each C> where repeat each C: RouteComponent {
        Tuple(content: (repeat each content))
    }

    // MARK: buildArray

    @inlinable
    public static func buildArray<C: RouteComponent>(_ content: [C]) -> Spread<[C]> {
        Spread(content: content)
    }

    // MARK: buildEither

    @inlinable
    public static func buildEither<TrueContent: RouteComponent, FalseContent: RouteComponent>(
        first content: TrueContent
    ) -> Conditional<TrueContent, FalseContent> {
        return Conditional.first(content)
    }

    @inlinable
    static func buildEither<TrueContent: RouteComponent, FalseContent: RouteComponent>(
        second content: FalseContent
    ) -> Conditional<TrueContent, FalseContent> {
        return Conditional.second(content)
    }

    // MARK: buildOptional

    @inlinable
    public static func buildOptional<C: RouteComponent>(_ content: C?) -> C? {
        content
    }

    // MARK: buildLimitedAvailability

    @inlinable
    public static func buildLimitedAvailability<C: RouteComponent>(_ content: C?) -> C? {
        content
    }
}
