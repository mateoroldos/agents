# Services and Layers

Apply the ownership and depth model in `references/MODULES.md` in the `type-driven-development` skill. An Effect service is an authority seam: a cohesive capability whose requirement should remain visible in the Effect type until a composition root chooses its implementation.

## Apply the service test

A service should own at least one meaningful capability:

- persistence, credentials, external I/O, configuration, time, randomness, or another authority;
- a runtime resource or lifecycle;
- cohesive application policy and effect sequencing reused across entrypoints;
- behavior with real production and test variation;
- enough hidden complexity that deleting the module would spread it into callers.

Keep parsed inputs, request values, deterministic calculations, schema models, and per-call options as values or pure modules. Do not create a service only to make a test injectable or to rename another service. Prefer an existing Effect capability before wrapping it.

## Default application module surface

For a new cohesive module, use one owner file with local role names and a canonical ES-module namespace projection:

```ts
// user-repo.ts
export interface Interface {
  readonly get: (
    id: UserId,
  ) => Effect.Effect<User, NotFound | PersistenceError>
}

export class Service extends Context.Service<Service, Interface>()(
  "@app/UserRepo",
) {}

export class NotFound extends Schema.TaggedError<NotFound>()(
  "UserRepo.NotFound",
  { id: UserId },
) {}

export const layer = Layer.effect(
  Service,
  Effect.gen(function* () {
    const sql = yield* SqlClient.SqlClient

    const get = Effect.fn("UserRepo.get")(function* (id: UserId) {
      // implementation
    })

    return Service.of({ get })
  }),
)

export * as UserRepo from "./user-repo.js"
```

```ts
import { UserRepo } from "./user-repo.js"

const users = yield* UserRepo.Service
const user = yield* users.get(id)
```

This is our local application convention, not official Effect doctrine. It gives the domain concept one stable identity—`UserRepo.Service`, `UserRepo.layer`, `UserRepo.NotFound`—without a TypeScript namespace or wrapper object.

- Import the namespace directly from its owning leaf.
- A folder or package barrel may relay that identity with `export { UserRepo } ...`; it should not recreate it.
- Keep row schemas, helpers, clients, and implementation details private.
- The self-reference `UserRepo.UserRepo === UserRepo` is unusual; use this only where the runtime and toolchain support it.
- Follow an established incompatible module convention rather than migrating for style.

## Place dependencies

- Yield stable dependencies while constructing the Layer and close over them in methods.
- Yield request-, fiber-, or operation-scoped context inside the method that uses it.
- Let requirements propagate until the module that owns the implementation choice provides them.
- Keep application-owned service contracts in application language; concrete adapters own technology Layers.
- Do not accept broad dependency bags or Layers as ordinary function arguments.

## Compose Layers deliberately

Choose a constructor that matches acquisition: an existing value, lazy synchronous construction, effectful acquisition, or a context supplying several services.

- Hide an implementation dependency when downstream callers should not provide it.
- Preserve a requirement when the caller truthfully owns the choice.
- Merge independent exposed services only when their topology remains clear.
- Prefer a flat, topologically readable runtime graph with named subgraphs.
- Do not use merge/provide combinators as blind make-it-compile tools.
- Do not hide authority behind a default reference unless the default is genuinely safe and ambient.

## Test implementations

- Use a complete static implementation for a trivial capability.
- Use a colocated stateful test service when reusable control and observation are part of the real seam.
- Call an implementation “memory” only when it faithfully implements the observable contract in memory.
- Use local infrastructure when persistence, serialization, transactions, or protocol behavior matters.
- Keep a narrow one-off fake in its test rather than creating application surface solely for testing.

When a reusable test-control service exists, back the production and control tags with the same object. Production depends only on the production tag; tests use the control tag to arrange failures and inspect outcomes.
