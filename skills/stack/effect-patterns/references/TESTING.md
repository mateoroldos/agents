# Testing

Use the installed Effect test integration and follow `references/TESTING.md` in the `type-driven-development` skill for test strategy.

## Defaults

- Use the Effect-aware test form for tests that run Effects or need Layers.
- Use an ordinary test for pure synchronous functions.
- Use a live-runtime test only when real time or live services are the behavior under test.
- Provide dependencies with test Layers and configuration providers, not global mutation.
- Use the installed assertion library and test helpers; current official guidance prefers `assert` from `@effect/vitest`.
- Test success, typed failure, interruption, finalization, rollback, retry bounds, idempotency, and malformed persistence where relevant.

```ts
it.effect("finds a user", () =>
  Effect.gen(function* () {
    const users = yield* UserRepo.Service
    const result = yield* users.get(UserId.make("u1"))

    assert.strictEqual(result.id, UserId.make("u1"))
  }).pipe(Effect.provide(UserRepo.testLayer)),
)
```

Verify the exact test API, automatic Scope behavior, and assertion exports against the installed packages.

## Control time

Use `TestClock` for sleeps, schedules, retries, leases, and timeouts. Fork an Effect that is waiting on time before advancing the clock. Do not use wall-clock sleeps to make a test “eventually” pass.

## Synchronize explicitly

- `Deferred` — one-shot readiness or completion.
- `Queue` — test-controlled work or observed events.
- `Latch` — reusable coordination gate.
- `Ref` — shared observation state.
- An explicit hook — when the production seam can expose a deterministic event.

Wait for the event that proves readiness; elapsed time is not evidence.

## Build honest test Layers

Use the module's production service interface for behavior. Add a separate control service only when reusable tests need to arrange failure or inspect hidden state. One object should back both tags so the control surface observes the exact implementation used by production code.

- Complete static capability → simple successful Layer.
- Reusable state and controls → stateful test service and Layer.
- Persistence or protocol semantics → real local adapter.
- Narrow one-off behavior → fixture in the test.

Do not expose production internals for tests or advertise a partial fixture as a reusable in-memory implementation.
