# Modules

A **module** hides an implementation behind an **interface**. The interface is everything callers must know: types, invariants, errors, ordering, configuration, and relevant performance constraints.

A **seam** is a place where behavior can vary without editing its caller. An **adapter** is a concrete implementation at a seam. A module is **deep** when its interface gives callers substantial capability while hiding knowledge and complexity.

## Assign ownership

Classify a responsibility by what would make it change:

- **Domain module** — meaning, invariant, calculation, or legal state transition.
- **Application service** — application policy, authorization, or effect sequence.
- **Adapter** — protocol, framework, database, runtime, or third-party translation.
- **Composition root** — configuration, resource construction, and concrete wiring.

These are roles, not required folders or classes. A pure operation may need only a domain function. Split code when it owns unrelated reasons to change, not to satisfy a layer diagram.

```text
external input → inbound adapter → application service → domain module
                                           │
                                           └→ owned port → outbound adapter → external system
```

Dependencies point toward meaning. Domain modules know no technology. Application services depend on application-shaped capabilities. Adapters translate those capabilities to concrete systems.

## Design deep modules

A deep module concentrates invariants, policy, sequencing, or translation behind a cohesive interface. It creates:

- **leverage** — many callers gain capability without relearning its implementation;
- **locality** — one change or fix remains in one owner.

Use three tests:

1. **Caller burden:** can methods, parameters, ordering rules, or required knowledge shrink?
2. **Deletion:** would removing the module spread complexity into callers, or make it disappear?
3. **Test surface:** can important behavior be proved through the same interface callers use?

One implementation rarely justifies a seam. Introduce one when behavior truly varies, an external boundary needs translation, or the interface itself creates meaningful isolation. For consequential interfaces, sketch at least two materially different shapes before choosing.

## Own ports at the use site

Define the smallest meaningful dependency beside the application operation that needs it and in that operation's language:

```ts
interface UsersForPasswordReset {
  readonly findActiveByEmail: (
    email: EmailAddress,
  ) => Promise<Result<ActiveUser, UserLookupError>>
}
```

A wider cohesive adapter can satisfy this structurally. This avoids both mega-interfaces and one-method adapter sprawl. Reuse an existing adapter first; extend it when the responsibility remains cohesive; create another only when the reason to change is genuinely different.

## Name for meaning and ownership

- Name modules after domain concepts or capabilities: `Invoice`, `PasswordReset`, `UserStore`.
- Name operations after observable behavior: `reserve`, `issue`, `findActiveByEmail`.
- Name boundary projections after their role: `CreateUserRequest`, `StripeCustomerResponse`, `UserRecord`.
- Keep one term for each concept across types, files, tests, and telemetry.
- Avoid `Manager`, `Processor`, `Helper`, `Utils`, `Common`, and `DTO` when a precise owner or role exists.

Keep cohesive concepts together. Do not split by arbitrary line counts or export internals merely to test them. Prefer imports from the file that owns the concept; aggregate exports may relay that identity but should not invent another one.
