---
name: spec-led-design
description: Use when the user asks for architecture, design, specs, API shape, domain modeling, seams/adapters, persistence/runtime boundaries, or asks to analyze before coding. Also use for non-trivial feature work where implementation should be planned before edits.
---

# Specification-Led Design

Use this skill to make implementation boring: clarify the domain, design the seam, then code behind it.

## Operating rule

Do not jump to code for non-trivial changes. First produce or confirm a compact spec. Keep it practical: enough design to prevent churn, not a ceremony.

## Spec template

For design work, outline:

1. **Problem**: what is broken, missing, or unclear.
2. **Domain language**: the terms the code and tests should use.
3. **Invariants**: what must always be true.
4. **Public seam**: the caller-facing interface.
5. **Internal modules**: who owns which responsibilities.
6. **Adapters**: IO/runtime/persistence implementations behind the seam.
7. **Type/API sketch**: TypeScript pseudo-code for important contracts.
8. **Callstacks**: how requests flow through modules.
9. **Test plan**: behaviors to verify through public seams.
10. **Implementation sequence**: small ordered diffs.
11. **Validation**: exact commands to run.

## Domain language workflow

- Search for existing glossary files, ADRs, docs, tests, and public APIs before naming new concepts.
- Reuse the project's language unless it is clearly wrong.
- Prefer business nouns and domain verbs over technical placeholders.
- If two names mean the same thing, pick one and call out the consolidation.
- If one name hides multiple concepts, split it before implementing.

## Seam and adapter checklist

Identify:

- the caller-facing seam
- the production adapter
- the memory/test adapter
- external boundaries: HTTP, DB, filesystem, queues, workers, browser APIs, subprocesses
- trust boundaries where `unknown` must be decoded
- where domain errors are created and mapped

Good seams are small and domain-shaped. Bad seams expose SQL rows, protocol details, rollback internals, framework objects, or fake-only behavior.

## Deep module checklist

Prefer modules that hide complexity behind a small interface.

A module should own:

- its invariants
- ordering rules
- error mapping
- transaction or compensation rules when they are implementation concerns
- adapter-specific details

Design smell: callers must know internal state machines, row shapes, temporary mutation objects, or repair mechanics.

## Type/API sketching

Use TypeScript pseudo-code to make the design concrete:

```ts
export class DomainService extends Context.Service<DomainService, {
  doThing(input: ParsedInput): Effect.Effect<Result, DomainError>
}>()("app/DomainService") {}
```

Show enough type shape to expose:

- inputs and outputs
- domain errors
- required services
- adapter boundaries
- parsed vs raw values

Avoid pretending pseudo-code is final. Label it as a sketch when exact APIs need implementation research.

## Callstack format

Use this style:

```text
HTTP handler
  -> DomainService
    -> Coordinator
      -> Store
      -> ExternalIndex
```

Name boundary crossings explicitly:

```text
Worker handler
  -> LinkCatalog
    -> Durable Object adapter
      -> Effect RPC over fetch
        -> LinkCatalog implementation
```

## Test planning

- Test behavior through public or intended seams.
- Prefer real local adapters, memory adapters, or test layers.
- Avoid fakes that reimplement databases, frameworks, or protocols.
- If a fake becomes complex, redesign the seam.
- Add regression tests for bug fixes when practical.
- Name tests by behavior, not implementation.

## Implementation sequencing

Prefer this order:

1. Confirm the spec or ask remaining questions.
2. Add/update tests around the target seam.
3. Implement the smallest behavior change.
4. Refactor only after behavior is protected.
5. Run targeted validation.
6. Report exact validation status.

Keep mechanical refactors separate from behavior changes when possible.

## Review checklist

Before editing, check:

- [ ] Domain terms are consistent.
- [ ] The caller-facing seam is clear.
- [ ] Adapters are behind the seam.
- [ ] External data is decoded at boundaries.
- [ ] Errors are domain-shaped and typed where practical.
- [ ] Tests verify behavior through public seams.
- [ ] The implementation can be delivered as small reviewable diffs.
