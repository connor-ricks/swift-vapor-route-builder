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
    Group("api", "v1") {
        Group("movies") {
            GET { ... }
            GET("latest") { ... }
            GET("popular") { ... }
            GET(":movie") { ... }
        }
        Group("books") {
            GET { ... }
            GET("new") { ... }
            GET("trending") { ... }
            GET(":book") { ... }
        }
    }
}
```

### Middleware

Sometimes you may want to wrap certain routes in middleware. A common use case requiring middleware could be authentication. You have have some routes that require middleware, and others that do now. Adding middleware using `@RouteBuilder` is similar to adding view modifiers in SwiftUI.

```swift
app.register {
    Group("api", "v1") {
        Group("profile") {
            GET("favorites") { ... }
            GET("friends") { ... }
        }
        .middleware(AuthenticationMiddleware())
        Group("books") {
            GET("new") { ... }
            GET("trending") { ... }
            GET(":book") { ... }
        }
    }
}
```

In the above example, you'll see that we've only wrapped our `/profile/*` endpoints in our `AuthenticationMiddleware`, while all of the `/book/*` endpoints have no middleware associated with them.

If you have more than one middleware... no worries, `.middleware(_:)` accepts a variadic amount of middleware.

```swift
Group {
    GET("foo") { ... }
    GET("bar") { ... }
        .middleware(Authentication(), Validator())
        .middleware(Reporter())
}
.middleware(Logging())
```

Remember that order matters here. Incoming requests will always execute middleware from the top of the tree to the bottom. So in the above example, the order of an incoming request would be as follows ➡️ `Logging`, `Reporter`, `Authentication`, `Validator`. Outgoing respones will always execute middleware in the reverse order. ➡️ `Validator`, `Authentication`, `Reporter`, `Logging`.

### Custom Route Components

Often times, as your routes grow, a single large definition can become unwieldly and cumbersome to read and update. Organization of routes can be straightforward with `@RouteBuilder`

```swift
struct MoviesUserCase: RouteComponent {
    var body: some RouteComponent {
        Group("movies") {
            MovieUseCase()
            GET("latest") { ... }
            GET("trending") { ... }
        }
    }
}

struct MovieUseCase: RouteComponent {
    var body: some RouteComponent {
        Group(":movie") {
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
Group("movies", ":movie") {
    Route(.OPTIONS, "credits") { ... }
}
``` 

### Websockets

Defining a websocket is as simple as using the `Socket` route component.

```swift
Group("api") {
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
        Group("\(category.rawValue)") {
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

### Route Metadata

Vapor supports adding metadata to your routes. To add your own metadata to a route within a `@RouteBuilder`, make use of either the `.description(_:)` modifier or the `.userInfo(key:value:)` modifier.

```swift
Group {
    GET("hello") {
        ...
    }
    .description("Says hello")
    .userInfo(key: "isBeta", value: true)
}
``` 
