# Streams

`Stream<A, E, R>` is an effectful, pull-based source of many `A` values that may fail with `E` and require `R`. Consumption controls demand and backpressure.

Use a Stream when values are naturally many, ordered over time, and benefit from transformation, interruption, or backpressure. Use a repeated Effect when only recurring work matters and no values are exposed.

## Choose a source

- finite in-memory values → iterable source;
- callback producer → private Queue exposed as a Stream;
- one item consumed by one worker → Queue;
- every subscriber receives each event → PubSub;
- current value plus changes → SubscriptionRef;
- paginated pull API → pagination constructor;
- external async iterable → async-iterable adapter;
- source created after reading dependencies → unwrapped Stream.

## Transform deliberately

- Pure mapping stays pure.
- Effectful mapping exposes its requirements and failures.
- Concurrent mapping has an explicit bound and preserves order unless unordered completion is intentional.
- Stateful mapping owns its state in the stream pipeline.
- Pagination uses the library abstraction unless cursor semantics require a loop that can early-return or accumulate before failure.

Do not collect an unbounded production stream into memory.

## Own consumers

Long-lived consumers belong to a Layer and are forked into its scope. Keep producer queues and refs private; expose a Stream when callers should consume events rather than push them.

```ts
export interface Interface {
  readonly events: Stream.Stream<ProviderEvent, ProviderError>
}
```

Use natural backpressure first. Add a buffer only after choosing what full means:

- suspend the producer;
- drop new values;
- slide out old values;
- allow unbounded growth only when another invariant provides the bound.

## Fail and recover visibly

Translate typed errors at the adapter that understands them. Recover narrowly when the consumer has a truthful fallback. Cause-level recovery belongs at supervision boundaries and must preserve interruption.

For keyed work, use a named scoped abstraction when each key must remain ordered but different keys may run concurrently. Do not scatter maps of fibers through consumers.

Test finite slices with finite sources or a test-controlled Queue. Coordinate with events and `TestClock`, not sleeps.
