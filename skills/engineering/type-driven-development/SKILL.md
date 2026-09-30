---
name: type-driven-development
description: How we judge TypeScript program design, types first. Use when modeling domain values, states, or failures; designing modules, interfaces, or seams; making reliability decisions; or when another skill needs the program-design model.
metadata:
  family: principle
---

# Type-Driven Development

Types carry what the program knows; tests prove only what types cannot. Judge every design and every diff by these rules.

## Model first

Write inputs, outputs, domain values, states, failures, and dependencies as types before the control flow. Make illegal states unrepresentable, and parse untrusted values into the model at the edge.

- **Why:** the compiler checks a type on every build; a comment or caller discipline is checked by no one.
- **Smell:** bags of optional fields, booleans that encode a state, `as` outside a parser, failures that exist only in prose.

## Trace it

Every changed behavior has a call stack from entrypoint to result, with parsing, authorization, transactions, retries, cancellation, and external calls on it where reachable.

- **Why:** a dependency or failure that appears by magic is where bugs hide.
- **Smell:** you cannot say who calls it or what happens when it fails.

## One owner

Each invariant, policy decision, effect sequence, and technology translation has one home. Dependencies point toward domain meaning.

- **Why:** two homes drift apart.
- **Smell:** the same check in two places; domain code importing a framework or provider.

## Deletion test

A module, seam, option, or mode stays only if deleting it would spread knowledge or complexity into its callers.

- **Why:** each concept is read far more often than it is written.
- **Smell:** pass-through modules, one-caller wrappers, an interface with one implementation and no test seam, an option no caller passes.

## Prove what types cannot

Test only what the types cannot rule out. The `audit-tests` skill decides whether a test lands, at which boundary, and how it is written.

- **Why:** a failure the compiler rules out needs no test to maintain.
- **Smell:** a test of what the types guarantee.

## Decision order

When rules conflict:

1. Preserve correctness, safety, and debuggability.
2. Preserve the behavior and constraints the change is not meant to alter.
3. Prefer the simpler model and smaller interface.
4. Follow compatible project conventions.
5. Contain incompatible legacy patterns at the nearest seam.
6. Leave unrelated code unchanged.

## References

Read every reference the task reaches before editing:

- Design proposals, technical plans, or implementation handoffs: [`references/DESIGN.md`](references/DESIGN.md).
- Domain values, parsing, brands, states, optionality, or failures: [`references/MODELING.md`](references/MODELING.md).
- Ownership, deep modules, interfaces, seams, ports, naming, or file placement: [`references/MODULES.md`](references/MODULES.md).
- Inference, strictness, casts, immutability, imports, exports, or documentation: [`references/TYPESCRIPT.md`](references/TYPESCRIPT.md).
- Resources, cancellation, transactions, retries, idempotency, configuration, secrets, or observability: [`references/RELIABILITY.md`](references/RELIABILITY.md).

Framework skills may refine how a rule is realized, but not overrule it.
