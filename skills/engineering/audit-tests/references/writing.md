# Writing a test

How to write a test that passed the gate. The `effect-patterns` skill realizes these rules for Effect.

## Assert what callers observe

Assert what a caller or neighboring system can observe:

- returned value or typed failure;
- persisted state;
- emitted event or message;
- rendered response;
- interruption, finalization, or rollback;
- bounded retries and idempotent results.

Assert an interaction only when the interaction is the contract. Tests and callers cross the same interface.

Name each test after the behavior it pins, such as `rejects an invitation accepted by another user`.

## Use honest substitutes

Avoid module replacement such as `vi.mock` and `jest.mock`. Replace behavior at real seams:

- a complete static implementation for a trivial capability;
- a stateful fake for reusable control and observation;
- a local database when queries, constraints, or transactions matter;
- a fake external adapter when the third party cannot run locally;
- a fixture local to one test when reuse would create false production surface.

A substitute must honor the observable contract implied by its name. A partial object that crashes on unused methods is a local fixture, not a reusable in-memory adapter.

## Prove type contracts

When types are part of a public contract, test accepted and rejected usage with compile-time tests. Cover inference, assignability, and narrowing that callers rely on; runtime tests cannot prove them.

## Make time and concurrency deterministic

Control clocks, randomness, identifiers, dependencies, and synchronization. Wait for explicit readiness or observed events rather than elapsed wall time.

## Use properties where laws matter

Property tests are especially useful for:

- parsers and smart constructors;
- state transitions;
- serialization round trips;
- normalization and idempotence;
- ordering and lawful combinators.

Generate values through the same constructors as production. Tests must not bypass the invariants they claim to prove.
