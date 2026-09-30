---
name: shape-feature
description: Shape an uncertain feature into an agreed contract, slices, and evidence before implementation. Use when a feature's behavior, scope, or slices are not yet agreed.
metadata:
  family: workflow
---

# Shape a Feature

Use progressive commitment: resolve product uncertainty before choosing technical shape, and choose technical shape before implementation. Do not implement while shaping.

## 1. Establish reality

Inspect the request, current behavior, relevant code and tests, existing product concepts, and prior decisions. Answer from available evidence instead of asking the user to rediscover repository facts.

**Complete when:** the affected actor, present problem, constraints, and consequential unknowns are distinguished from assumptions.

## 2. Resolve product decisions

Interview the user only about answers that could change whether the feature belongs, its observable behavior, scope, risk, or permanent complexity. Test the idea against existing concepts, realistic scenarios, edge cases, and the option not to build it.

Keep implementation preferences provisional. Record unresolved decisions explicitly rather than inventing them.

**Complete when:** every consequential question the user can answer is resolved, or the remaining questions visibly block further commitment.

## 3. Define the feature contract

Describe the smallest coherent outcome from the user's perspective:

- the problem and affected actor;
- desired behavior as concrete scenarios;
- non-goals;
- constraints and invariants;
- observable acceptance evidence;
- remaining decisions or risks.

Separate accepted product behavior from proposed implementation. Do not add sections that carry no decision.

**Complete when:** every promised behavior has observable proof and the contract does not silently expand beyond the demonstrated problem.

## 4. Choose the next commitment

Recommend the smallest path that resolves the remaining uncertainty:

- **Direct change** when the behavior and implementation are routine and bounded.
- **Prototype** when one feasibility, interaction, or state-model question needs a disposable answer.
- **Technical design** when contracts, ownership, failure flow, migration, or architecture remain consequential.
- **Vertical slices** when the feature exceeds one focused implementation context. Each slice must deliver a narrow, complete, independently verifiable behavior and declare genuine blockers.
- **Expand–migrate–contract** when a wide mechanical change cannot remain valid as vertical slices.

Do not introduce parallel writers unless the selected slices have independent ownership and isolated workspaces.

**Complete when:** one delivery path is selected, its reason is explicit, and implementation can begin without unresolved product invention.

## Handoff

Write the plan to `plans/<name>.md` in the plan format of the `build` skill: the step 3 contract, the decisions, and the slices of the chosen path, each with its evidence.

**Complete when:** the plan holds a contract and slices ready for approval, or a precise list of the decisions blocking one; no implementation has begun.
