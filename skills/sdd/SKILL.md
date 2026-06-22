---
name: sdd
description: Service-driven development for Effect applications using service contracts, layers, test layers, and top-level dependency composition. Use when designing or implementing Effect services, Context.Service tags, Layers, dependency graphs, or orchestration services.
---

# Effect Service-Driven Development

## Use with Effect guidance

When using this skill, also apply the `effect-ts` and `ts-standards` skill guidance. For implementation details, read:

- `../effect-ts/references/guide-layers.md`
- `../effect-ts/references/guide-testing.md`
- `../effect-ts/references/guide-observability.md`

## Core idea

Design the application as explicit service contracts first, then compose implementations with Layers.

- **Service**: a typed contract and unique identity, usually `Context.Service`.
- **Layer**: an implementation recipe that may acquire resources and depend on other services.
- **Program**: business logic that yields services and stays implementation-agnostic.
- **Entry point**: the only place that provides the final composed application layer.

## SDD workflow

1. **Model the domain boundary**
   - Define branded IDs and domain models with `Schema` where practical.
   - Parse unknown/external input into domain values at the service boundary.
   - Define tagged, typed domain errors before implementation details leak in.

2. **Sketch leaf service contracts first**
   - Create `Context.Service` classes with method signatures only.
   - Use unique identifiers like `@app/Users` or `@feature/Payments`.
   - Keep method return dependencies as `R = never`; layer composition handles dependencies.

3. **Write orchestration services against contracts**
   - Higher-level services yield leaf services with `yield* Service`.
   - Implement business operations with `Effect.fn("Service.method")` for tracing.
   - Do not provide layers inside business logic.

4. **Add test layers early**
   - Use `Layer.sync` or `Layer.succeed` for simple fakes.
   - Keep per-test layer instances fresh unless sharing an expensive resource is intentional.
   - Prefer `@effect/vitest` layer helpers for Effect tests.

5. **Add production layers last**
   - Implement external resources at the edges: HTTP, database, email, queues, config.
   - Decode external data with `Schema`; do not trust unknown input.
   - Map integration failures into typed domain errors at service boundaries.

6. **Compose once at the edge**
   - Build a named `appLayer` in application assembly code.
   - Call `Effect.provide(appLayer)` at the runtime boundary only.
   - Keep config/resource acquisition in layers or bootstrap code, not import-time side effects.
   - Reuse parameterized layer constants to preserve Layer memoization.

## Service rules

- Prefer `class Name extends Context.Service<Name, Shape>()("@app/Name") {}`.
- Service shapes expose readonly methods, not mutable state.
- Methods return typed `Effect.Effect<Success, Error>` values.
- Keep errors precise at service boundaries; avoid broad app-wide errors until entrypoints/logging/rendering.
- Avoid thin exported accessor functions that only forward to one service method.
- Prefer explicit service shapes when doing SDD; use inferred `make` only for small obvious implementations.

## Layer rules

- Use `Service.layer` for the default production implementation.
- Use `Service.layerMemory` for in-memory test/development implementations.
- Use `Service.layerFromEnv` for implementations built from environment/config.
- Use purpose-specific names when needed, e.g. `Service.layerDurableObject`.
- Do not use `Live` suffixes for production layers.
- Use `Layer.effect` when constructing with effects or dependencies.
- Use `Layer.scoped` for resources that need cleanup.
- Store parameterized layers in constants before reusing them in multiple places.
- Keep wiring separate from business logic.

## Review checklist

- [ ] Service identifiers are unique and stable.
- [ ] Leaf service contracts compile before implementations exist.
- [ ] Business logic depends on contracts, not concrete clients.
- [ ] Service methods do not require unprovided runtime dependencies.
- [ ] External responses are schema-decoded at boundaries.
- [ ] Errors are typed and meaningful at the domain boundary.
- [ ] Tests use test layers, not internal mocks, where practical.
- [ ] The application provides one composed layer at the edge.

## Reference

See [patterns.md](patterns.md) for templates, examples, anti-patterns, and a deeper explanation of the services-and-layers workflow.
