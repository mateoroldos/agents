# Effect SDD Patterns

This reference distills the Effect services-and-layers workflow from <https://www.effect.solutions/services-and-layers> into implementation rules for agents.

## Mental model

Service-driven development starts with contracts, not implementations. A service class declares a unique identity and a method shape. Layers later provide concrete implementations and wire dependencies.

This lets higher-level orchestration code compile before lower-level infrastructure exists. The orchestration code is real TypeScript and real Effect code; it is only not runnable until its required layers are supplied.

## Minimal service contract

```ts
import { Effect } from "effect"
import * as Context from "effect/Context"

class Users extends Context.Service<
  Users,
  {
    readonly findById: (id: UserId) => Effect.Effect<User, UserNotFound>
  }
>()("@app/Users") {}
```

Rules:

- The tag string must be unique. Prefer `@app/ServiceName` or `@feature/ServiceName`.
- Method properties are `readonly`.
- Method effects should usually have `R = never`; dependencies belong in layers.
- Define typed errors in the service contract when callers must handle them.

## Orchestration service

```ts
import { Clock, Effect, Layer } from "effect"
import * as Context from "effect/Context"

class Events extends Context.Service<
  Events,
  {
    readonly register: (eventId: EventId, userId: UserId) => Effect.Effect<Registration, RegistrationError>
  }
>()("@app/Events") {
  static readonly layer = Layer.effect(
    Events,
    Effect.gen(function* () {
      const users = yield* Users
      const tickets = yield* Tickets
      const emails = yield* Emails

      const register = Effect.fn("Events.register")(function* (eventId: EventId, userId: UserId) {
        const user = yield* users.findById(userId)
        const ticket = yield* tickets.issue(eventId, userId)
        const now = yield* Clock.currentTimeMillis

        const registration = new Registration({
          id: RegistrationId.make(crypto.randomUUID()),
          eventId,
          userId,
          ticketId: ticket.id,
          registeredAt: new Date(now),
        })

        yield* emails.send(user.email, "Event Registration Confirmed", `Your ticket code: ${ticket.code}`)

        return registration
      })

      return { register }
    }),
  )
}
```

Why this works:

- `Events` depends on service contracts only.
- Leaf services can be unimplemented while orchestration compiles.
- `Events.layer` states its dependencies through the layer type.
- `Effect.fn("Events.register")` gives useful traces and stack frames.

## Production layer template

```ts
class Users extends Context.Service<
  Users,
  {
    readonly findById: (id: UserId) => Effect.Effect<User, UserNotFound | UsersUnavailable | Schema.SchemaError>
  }
>()("@app/Users") {
  static readonly layer = Layer.effect(
    Users,
    Effect.gen(function* () {
      const http = yield* HttpClient.HttpClient

      const findById = Effect.fn("Users.findById")((id: UserId) =>
        Effect.gen(function* () {
          const response = yield* http.get(`/users/${id}`)
          return yield* HttpClientResponse.schemaBodyJson(User)(response)
        }).pipe(
          Effect.catch((err) => Effect.fail(new UsersUnavailable({ id, cause: err }))),
        ),
      )

      return { findById }
    }),
  )
}
```

Boundary rules:

- Acquire external clients inside layers, not in pure domain code.
- Decode unknown responses with `Schema` before returning domain values.
- Convert transport/infrastructure failures into service-level typed errors.
- Keep retry, timeout, and observability policy close to the integration boundary unless the domain explicitly owns it.

## Test layer template

```ts
class Users extends Context.Service<
  Users,
  {
    readonly findById: (id: UserId) => Effect.Effect<User, UserNotFound>
  }
>()("@app/Users") {
  static readonly testLayer = Layer.sync(Users, () => {
    const records = new Map<UserId, User>([
      [UserId.make("user-1"), new User({ id: UserId.make("user-1"), name: "Ada", email: "ada@example.com" })],
    ])

    const findById = (id: UserId) =>
      Effect.fromNullable(records.get(id)).pipe(
        Effect.mapError(() => new UserNotFound({ id })),
      )

    return { findById }
  })
}
```

Testing rules:

- Prefer fresh layers per test for stateful fakes.
- Use suite-shared layers only for expensive resources and document the state-sharing risk.
- Test orchestration through its public service method.
- Avoid mocking internal implementation functions when a test layer can express the dependency.

## Application composition

```ts
const postgresLayer = Postgres.layer({ url: cfg.databaseUrl, poolSize: 10 })

const usersLayer = Users.layer.pipe(Layer.provide(postgresLayer))
const ticketsLayer = Tickets.layer.pipe(Layer.provide(postgresLayer))
const emailsLayer = Emails.layer.pipe(Layer.provide(emailClientLayer))

const appLayer = Events.layer.pipe(
  Layer.provideMerge(usersLayer),
  Layer.provideMerge(ticketsLayer),
  Layer.provideMerge(emailsLayer),
)

const main = program.pipe(Effect.provide(appLayer))
```

Memoization rule:

- Layer memoization is by reference identity.
- If a parameterized layer is used more than once, assign it to a `const` and reuse that same value.
- Do not call `Postgres.layer(cfg)` separately in two branches unless two instances are intentional.

## Anti-patterns

### Providing inside business logic

```ts
// Bad: hides wiring and makes tests harder
const program = Events.register(eventId, userId).pipe(Effect.provide(Events.layer))
```

Prefer providing once in application assembly or test setup.

### Dependencies in service method requirements

```ts
// Bad: pushes dependency wiring to every caller
readonly findById: (id: UserId) => Effect.Effect<User, UserNotFound, HttpClient.HttpClient>
```

Prefer acquiring `HttpClient` inside `Users.layer`, so `findById` itself needs no runtime environment.

### Duplicate parameterized layers

```ts
// Bad: likely creates two pools
UserRepo.layer.pipe(Layer.provide(Postgres.layer(cfg)))
OrderRepo.layer.pipe(Layer.provide(Postgres.layer(cfg)))
```

Prefer:

```ts
const postgresLayer = Postgres.layer(cfg)
UserRepo.layer.pipe(Layer.provide(postgresLayer))
OrderRepo.layer.pipe(Layer.provide(postgresLayer))
```

### Mutable services

```ts
// Bad: exposed mutable state
class Cache extends Context.Service<Cache, { store: Map<string, string> }>()("@app/Cache") {}
```

Prefer readonly effectful methods: `get`, `set`, `delete`, `clear`.

## Design checklist

Use this before implementation:

1. What domain capability is this service responsible for?
2. Is it a leaf service, orchestration service, or infrastructure adapter?
3. What domain models and branded IDs cross its boundary?
4. What errors can callers recover from?
5. Which dependencies should be yielded inside the layer?
6. What is the simplest useful test layer?
7. Where will the production layer be composed into `appLayer`?
