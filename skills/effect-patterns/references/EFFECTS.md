# Effects

An Effect type must truthfully expose its success value, expected failures, and required services.

## Construct workflows

- Use `Effect.gen` for an inline workflow where imperative sequencing is clearest.
- Use the installed `Effect.fn` form for reusable workflows and useful tracing boundaries.
- Use the untraced form for internal or hot-path functions where a span and stack frame add no value.
- Attach whole-operation behavior—error classification, annotations, retry, timeout, cleanup—with a small number of readable combinators.
- Keep pure calculations and domain decisions outside Effect unless they need an Effect capability or typed effect failure.

When yielding a failure, return it so TypeScript knows the workflow stops:

```ts
if (!allowed) return yield* new PermissionDenied({ actorId })
```

## Translate foreign effects once

Wrap Promise, callback, and throwing APIs in the adapter that understands them. Preserve cancellation signals where the foreign API supports them and translate rejection into a specific application error before it escapes.

Do not use `async`/`await` or `try`/`catch` inside an Effect workflow to create a second invisible failure channel.

## Recover narrowly

- Recover by tag or predicate when policy understands a specific expected failure.
- Preserve unhandled errors in the channel.
- Inspect causes only at supervision, runtime, or adapter boundaries that must distinguish defects and interruption.
- Never catch broadly merely to make the error channel disappear.
- A fallback must be a truthful application outcome, not hidden data loss.

Changing broad recovery into narrow recovery can expose previously swallowed failures. Audit callers before treating it as mechanical cleanup.

## Time and concurrency

Use Effect time and date capabilities inside Effect code rather than ambient `Date.now()` or `new Date()`. This preserves determinism and clock control.

Prefer structured concurrency:

- fork into a scope whose lifetime matches the work;
- use bounded concurrency for collections and streams;
- coordinate with `Deferred`, `Queue`, `Latch`, `Ref`, or another explicit primitive;
- preserve interruption through wrappers and recovery;
- do not replace a loop with collection combinators when it early-returns, breaks, or accumulates before failure.

Use higher-level Schedule, Stream, Cache, and Request abstractions only when their semantic model matches the problem; their focused references explain the choice.
