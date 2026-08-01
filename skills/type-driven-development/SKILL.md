---
name: type-driven-development
description: Type-driven TypeScript development. Use when modeling domain values, states, or failures; writing technical designs; defining modules, interfaces, or seams; choosing tests; making reliability decisions; or when another skill needs the shared program-design model.
---

# Type-Driven Development

Use types to expose ambiguity early, preserve what parsing proves, make dependencies and failures visible, and give modules honest interfaces.

## Working sequence

### 1. Inspect

Read the relevant implementation, tests, and local conventions before introducing a pattern, dependency, interface, or module.

**Complete when:** the affected entrypoints, caller-visible behavior, ownership, existing tests, reachable runtime constraints, and project validation commands have been located.

### 2. Model

Write the important inputs, outputs, domain values, states, expected failures, and dependencies before the control flow. Make illegal states unrepresentable where practical and parse untrusted values into the model at the edge.

**Complete when:** the signatures describe valid states and reachable failures without relying on comments or caller discipline.

### 3. Trace

Trace each changed caller-visible behavior from entrypoint to result and every side effect. Mark parsing, authorization, transactions, retries, cancellation, and external crossings when reachable.

**Complete when:** every changed behavior has an end-to-end call stack and no dependency or failure appears by magic.

### 4. Assign

Give each invariant, policy decision, effect sequence, and technology translation one owner. Put interfaces at the smallest real seams and keep dependencies pointed toward domain meaning.

**Complete when:** every changed responsibility has one reason to change and one discoverable home.

### 5. Simplify

Remove speculative seams, pass-through modules, duplicate representations, modes, and options. Prefer one clear flow and the smallest interface that hides the real complexity.

**Complete when:** every new concept survives the deletion test: removing it would spread knowledge or complexity into callers.

### 6. Prove

Test observable behavior through the same interfaces callers use. Choose the highest-confidence affordable seam and control time, concurrency, dependencies, and data deterministically.

**Complete when:** each changed behavior, invariant, and expected failure has an observable proof at a trustworthy seam; the smallest applicable typecheck and behavioral checks pass, or every failure and untested claim is reported.

## Decision order

When concerns conflict:

1. Preserve correctness, safety, and debuggability.
2. Preserve the behavior and constraints the change is not meant to alter.
3. Prefer the simpler model and smaller interface.
4. Follow compatible project conventions.
5. Contain incompatible legacy patterns at the nearest seam.
6. Leave unrelated code unchanged.

## Chooser

Read only the references reached by the task:

- Design proposals, technical plans, or implementation handoffs: [`references/DESIGN.md`](references/DESIGN.md).
- Domain values, parsing, brands, states, optionality, or failures: [`references/MODELING.md`](references/MODELING.md).
- Ownership, deep modules, interfaces, seams, ports, naming, or file placement: [`references/MODULES.md`](references/MODULES.md).
- Test level, test doubles, observable outcomes, deterministic tests, or properties: [`references/TESTING.md`](references/TESTING.md).
- Inference, strictness, casts, immutability, imports, exports, or documentation: [`references/TYPESCRIPT.md`](references/TYPESCRIPT.md).
- Resources, cancellation, transactions, retries, idempotency, configuration, secrets, or observability: [`references/RELIABILITY.md`](references/RELIABILITY.md).

Read every matching branch before editing. Framework-specific skills may refine the realization, but not erase the model.
