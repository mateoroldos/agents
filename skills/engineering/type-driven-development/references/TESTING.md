# Testing

Tests are proofs about observable behavior, not transcripts of implementation calls.

## Choose the confidence seam

Prefer the highest-confidence test that is reliable and proportionate:

1. End-to-end through a real public entrypoint.
2. Integration through real module and infrastructure seams.
3. Focused examples or properties for pure domain modules.
4. Unit tests for meaningful isolated behavior.

Add lower-level tests when they cover important cases more precisely, not merely because the code has more functions.

## Observe outcomes

Assert what a caller or neighboring system can observe:

- returned value or typed failure;
- persisted state;
- emitted event or message;
- rendered response;
- interruption, finalization, or rollback;
- bounded retries and idempotent results.

Avoid assertions about private calls and ordering unless that interaction is the contract itself. Tests and callers should cross the same interface.

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

Control clocks, randomness, identifiers, dependencies, and synchronization. Wait for explicit readiness or observed events rather than elapsed wall time. A sleep is not proof that concurrent work finished.

Regression tests first reproduce the failure. Refactors preserve passing behavior before and after the change.

## Use properties where laws matter

Property tests are especially useful for:

- parsers and smart constructors;
- state transitions;
- serialization round trips;
- normalization and idempotence;
- ordering and lawful combinators.

Generate values through the same constructors as production. Tests must not bypass the invariants they claim to prove.
