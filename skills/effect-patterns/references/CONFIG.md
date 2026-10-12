# Configuration

Configuration is parsed input, not ambient application state.

## Read at the edge

- Describe runtime configuration with Effect `Config` recipes.
- Read recipes while constructing the Layer that owns the configured capability.
- Use a redacted recipe for credentials.
- Parse constrained values with Schema or a typed mapping.
- Represent semantic absence explicitly.
- Apply defaults only to missing values; malformed values should still fail.
- Do not read `process.env` inside application workflows.

```ts
export const layerFromEnvironment = Layer.effect(
  Configuration.Service,
  Effect.gen(function* () {
    const apiKey = yield* Config.redacted("API_KEY")
    const enabled = yield* Config.boolean("FEATURE_ENABLED").pipe(
      Config.withDefault(false),
    )

    return Configuration.Service.of({ apiKey, enabled })
  }),
)
```

## Providers

Replace the active `ConfigProvider` at the application or test composition root. Use deterministic providers in tests rather than mutating global environment variables. Add fallback or nested providers only when precedence and scope are deliberate.

Treat `.env`, filesystem, platform bindings, and process environment as adapter sources. Translate them into application configuration once.

## Concrete and config-backed Layers

An application capability may expose:

- a concrete Layer constructor for composition and tests;
- a config-backed Layer for the production root.

Do not force library-style `layerConfig` helpers onto every application module. Add both forms only when callers genuinely need both construction paths.
