---
name: effect-patterns
description: Effect application patterns. Use when writing or reviewing Effect workflows, schemas, errors, services, Layers, configuration, resource lifecycles, concurrency, schedules, streams, caches, HTTP integrations, tests, or service architecture.
compatibility: Requires Effect v4 and its installed package guidance.
---

# Effect Application Patterns

Realize the model from [`../type-driven-development/SKILL.md`](../type-driven-development/SKILL.md) with Effect. This skill owns application taste; the installed `effect` package owns API truth.

```text
unknown input
  → Schema
  → domain values
  → Effect<Output, Failure, Requirements>
  → Context.Service requirements
  → Layer implementations
  → composition root
  → observable result
```

## Establish API truth

Effect v4 moves quickly. Never recommend an API from memory.

1. Resolve the exact installed version from the manifest and lockfile.
2. Read the nearest project instructions and `node_modules/effect/AGENTS.md` completely.
3. Identify every material Effect API or concept in the change.
4. Search the installed `node_modules/effect/ai-docs/`, then `node_modules/effect/src/` and nearby package tests for each one.
5. Use project conventions for application shape where they remain compatible with the installed API and the type-driven model.

**Complete when:** every material API or pattern has version-matched guidance, or source inspection established that no focused guidance exists.

The separate official [`../effect-ts/SKILL.md`](../effect-ts/SKILL.md) owns repository setup and installation. Do not change the Effect version unless the task requires it.

## Application defaults

- Use Schema to decode untrusted data and model domain values in Effect applications.
- Keep pure domain decisions pure; use Effect to sequence policy and capabilities.
- Represent expected failures in the error channel with specific, structured errors.
- Use a service for a cohesive capability or authority, not every function or value.
- Let requirements propagate until the composition root truthfully chooses implementations.
- Acquire resources and fork background work in an owning scope.
- Name reusable workflows and useful tracing boundaries; avoid spans on trivial hot-path helpers.
- Test Effects with explicit Layers and deterministic clocks and synchronization.
- Preserve interruption, failure context, observability, idempotency, and runtime constraints.
- Treat explanatory workaround comments as evidence; verify before changing them.

## Module identity

For new cohesive application modules, default to the canonical namespace projection in [`references/SERVICES.md`](references/SERVICES.md). It is a local convention, not an Effect requirement. Follow an established incompatible project convention and do not migrate existing modules merely for style.

## Chooser

Read only the branches reached by the task:

- Schema, domain data, brands, variants, decoding, optionality, or schema-backed errors: [`references/DATA.md`](references/DATA.md).
- Effect construction, reusable workflows, typed recovery, Promise interop, time, or basic concurrency: [`references/EFFECTS.md`](references/EFFECTS.md).
- Service-or-value decisions, module surfaces, Context services, Layers, or runtime topology: [`references/SERVICES.md`](references/SERVICES.md).
- Scope, acquisition, finalizers, background work, runtimes, interruption, or observability: [`references/RUNTIME.md`](references/RUNTIME.md).
- Runtime configuration or `ConfigProvider`: [`references/CONFIG.md`](references/CONFIG.md).
- Effect tests, test Layers, time, concurrency, or fakes: [`references/TESTING.md`](references/TESTING.md).
- Retry, repeat, polling, pacing, backoff, or timeouts: [`references/SCHEDULING.md`](references/SCHEDULING.md).
- Streams, event sources, queues, pubsub, pagination, or backpressure: [`references/STREAMS.md`](references/STREAMS.md).
- Memoization, keyed caches, lookup deduplication, or request batching: [`references/CACHING.md`](references/CACHING.md).
- Outgoing HTTP, response decoding, status handling, or HTTP retry: [`references/HTTP.md`](references/HTTP.md).
- Exhaustive service, Layer, and composition review: [`references/SERVICE-REVIEW.md`](references/SERVICE-REVIEW.md).

Read every matching branch before editing. Recheck exact names and signatures against the installed package even when an example here looks applicable.
