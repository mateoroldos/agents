# Plan template

A plan lives at `plans/<name>.md` in the project repository and is deleted by the pull request that lands its final slice. Keep only the sections that carry a decision.

```markdown
# <Feature or bug, as the behavior>

Track: big feature | big fix [+ stakes] · Status: shaping | approved | building

<Two or three lines: the problem, who has it, and what "done" means.>

## Contract                    <!-- feature: from the shape-feature skill -->

- Scenarios: <concrete behavior, as the user sees it>
- Non-goals: <what this deliberately does not do>
- Constraints: <invariants that must hold>

## Diagnosis                   <!-- fix: from the diagnose skill -->

Symptom → cause → root, each with its evidence.

## Shape

<The new or changed types and signatures, as code. One call stack per changed behavior.>

## Decisions

- <decision>: <choice> (<why>)
- Open: <question that blocks a slice>

## Slices

- [ ] `<change subject>`: <the behavior it adds>
  - Proof: types | test `<name>` (<level>) | app: <what to check> | review: <why that is enough>
```

Choose each slice's proof with the `audit-tests` skill. A test not named here lands only with a reason in the review packet.
