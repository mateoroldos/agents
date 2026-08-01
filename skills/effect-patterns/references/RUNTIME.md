# Runtime and Resources

Resource lifetime, interruption, and observability are part of the application design.

## Acquire in scope

Use the installed scoped acquisition and finalizer APIs for files, clients, connections, locks, temporary state, and subscriptions. The scope must match the lifetime promised by the interface.

- Acquire stable resources while building their owning Layer.
- Release them on success, expected failure, defect, and interruption.
- Do not acquire an expensive client inside each service method or cache lookup.
- Do not leak `Scope` through a public service interface merely to control implementation lifetime.

## Own background work

A Layer that starts a listener, stream consumer, worker, or forever loop must fork it into the Layer's scope and finish acquisition:

```ts
export const layer = Layer.effectDiscard(
  Effect.gen(function* () {
    const events = yield* Events.Service

    yield* events.stream.pipe(
      Stream.runForEach(handleEvent),
      Effect.forkScoped,
    )
  }),
)
```

Use the installed scoped-fiber, fiber-set, or fiber-map abstraction that fits the ownership model. Expose `start` and `stop` only when manual lifecycle control is a real application capability.

## Run at the edge

Build the application Layer once at the composition root. Use the platform runtime or `Layer.launch` form documented by the installed packages for process entrypoints. Use a managed runtime when an external framework must repeatedly enter the same Effect application.

Do not scatter `runPromise`, runtime construction, or concrete `provide` calls through application modules. Runtime execution is an adapter concern.

## Preserve interruption

Interruption is not an ordinary expected failure. Promise wrappers, retries, broad cause handling, workers, and stream consumers must preserve it. Supervision may report a non-interruption cause and continue only when best-effort execution is the declared policy.

## Observe useful boundaries

Name spans around caller-visible application operations and external calls. Annotate them with safe domain identifiers, operation names, dependency names, retry counts, and error tags.

Avoid spans on trivial or per-element hot-path helpers. Changing span names, cardinality, or error status can break dashboards and budgets; inspect current telemetry before “improving” instrumentation.
