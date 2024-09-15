# Vapor Route Builder

Build and define Vapor routes using a declarative syntax langauge similar to how you would write SwiftUI views.

[Learn more](https://github.com/vapor/vapor) about 💧 Vapor, an HTTP web framework for Swift.

## Usage

> [!IMPORTANT]  
> Before learning about `@RouteBuilder`, make sure you've [learned the basics](https://docs.vapor.codes/basics/routing/) of routing with Vapor.

Defining routes using `@RouteBuilder` is fairly straightforward. You simply call `.register(_:)` on your `Application`, providing the routes that you wish to support.

```swift
app.register {
    GET("latest") { ... }
    GET("popular") { ... }
    POST("favorite") { ... }
}
```

### Path Groups

You can use `Group` to help organize your routes and cut down on the repetitiveness of defining long paths.

```swift
app.register {
    Group(path: "api", "v1") {
        Group(path: "movies") {
            GET("latest") { ... }
            GET("popular") { ... }
            GET(":movie") { ... }
        }
        Group(path: "books") {
            GET("new") { ... }
            GET("trending") { ... }
            GET(":book") { ... }
        }
    }
}
```

### Middleware Groups

Sometimes you may want to wrap certain routes in middleware. A common use case requiring middleware could be authentication. You have have some routes that require middleware, and others that do now. Adding middleware using `@RouteBuilder` is similar to wrapping routes in `Group(path:)`.

```swift
app.register {
    Group(path: "api", "v1") {
        Group(middleware: AuthenticationMiddleware()) {
            Group(path: "profile") {
                GET("favorites") { ... }
                GET("friends") { ... }
            }
        }
        Group(path: "books") {
            GET("new") { ... }
            GET("trending") { ... }
            GET(":book") { ... }
        }
    }
}
```

In the above example, you'll see that we've only wrapped our `/profile/*` endpoints in our `AuthenticationMiddleware`, while all of the `/book/*` endpoints have no middleware associated with them.

If you have more than one middleware... no worries, `Group(middleware:)` accepts a variadic amount of middleware.

```swift
Group(middleware: Logging()) {
    GET("foo") { ... }
    Group(middleware: Authentication(), Validator()) {
        GET("bar") { ... }
    }
}
```

Remember that order matters here. Incoming requests will always execute middleware from top to bottom. So in the above example, the order of an incoming request would be as follows ➡️ `Logging`, `Authentication`, `Validator`. Outgoing respones will always execute middleware in the reverse order. ➡️ `Validator`, `Authentication`, `Logging`.

### Making Custom Route Components

Often times, as your routes grow, a single large definition can become unwieldly and cumbersome to read and update. Organization of routes can be straightforward with `@RouteBuilder`

```swift
struct MoviesUserCase: RouteComponent {
    var body: some RouteComponent {
        Group(path: "movies") {
            MovieUseCase()
            GET("latest") { ... }
            GET("trending") { ... }
        }
    }
}

struct MovieUseCase: RouteComponent {
    var body: some RouteComponent {
        Group(path: ":movie") {
            GET("credits") { ... }
            GET("related") { ... }
        }
    }
}

struct BooksUseCase: RouteComponent {
    var body: some RouteComponent {
        ...
    }
}

app.register {
    MoviesUseCase()
    BooksUseCase()
}
```

### Convenience Routes

This package ships with a few conveniences for creating routes. You can use `GET`, `POST`, `PUT`, `PATCH`, and `DELETE` to cut down on the verbosity of defining your routes. If you need more fine grained control, you can always fall back to using a `Route` directly in your `@RouteBuilder`

```swift
Group(path: "movies", ":movie") {
    Route(.OPTIONS, "credits") { ... }
}
``` 

### Websockets

Defining a websocket is as simple as using the `Socket` route component.

```swift
Group(path: "api") {
    Socket("foo") { ... }
}
```

### Expressions & Logic

`@ResultBuilder` supports a wide variety of the available result builder syntax.

```swift
app.register {
    if isStaging {
        GET("configuration") { ... }
        POST("configuration") { ... }
    }
    
    GET("latest") { ... }
}
```

```swift
app.register {
    for category in categories {
        Group(path: "\(category.rawValue)") {
            switch category {
            case .movies:
                GET(":movie") { ... }
            case .books:
                GET(":book") { ... }
            }
        }
    }
}
```

### Interoperability

For existing vapor applications, it may be unreasonable or unwieldly to rewrite your entire routing stack in one go. You can start with replacing smaller sections of your route definitions by registering a `RouteComponent` on any `RoutesBuilder` in your application.


```swift
let users = app.grouped("users")
users.get(":user") { ... }
users.get("popular") { ... }
...

let books = app.grouped("books")
books.register { 
    GET("latest") { ... }
    GET("trending") { ... }
}
```

### RouteModifiers

- Currently undocumented.

## TODO

- [Confirmed] Implement Websocket support
- [Confirmed] Handle routes at the root of a RouteComponent.

```swift
Group(path: ":movie") {
    ... How do we handle JUST ":movie"?
    GET("credits") { ... }
    GET("category") { ... }
}
```

- [Maybe] Implement EnvironmentObject style support.
- [Maybe] Implement Service support 
- [Maybe] Route modifier for description.
- [Maybe] Route modifier for caseInsensitive.
- [Maybe] Route modifier for defaultMaxBodySize.
