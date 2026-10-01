---
name: shape-feature
description: Shape an uncertain feature into an agreed contract before anyone designs or builds it. Use when a feature's behavior or scope is not yet agreed.
metadata:
  family: workflow
---

# Shape a Feature

Resolve what to build and why before deciding how. Write no design and no code while shaping.

## 1. Establish reality

Inspect the request, current behavior, relevant code and tests, existing product concepts, and prior decisions. Answer from available evidence instead of asking the user to rediscover repository facts.

Done when the affected actor, present problem, constraints, and consequential unknowns are distinguished from assumptions.

## 2. Resolve product decisions

Interview the user only about answers that could change whether the feature belongs, its observable behavior, scope, risk, or permanent complexity. Ask one question at a time, with your recommended answer. Test the idea against existing concepts, realistic scenarios, edge cases, and the option not to build it.

Keep implementation preferences provisional. Record unresolved decisions explicitly rather than inventing them.

Done when every consequential question the user can answer is resolved, or the remaining questions visibly block further commitment.

## 3. Write the contract

Write the Contract section of `plans/<name>.md`, in the plan format of the `build` skill: the smallest coherent outcome, as the user sees it. Record each product decision and open question in its Decisions section.

Done when every scenario is observable, the contract does not expand beyond the demonstrated problem, and no implementation has begun.
