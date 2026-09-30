# Designing

Use this branch when the requested result is a design proposal, technical plan, or implementation handoff rather than code. The rules in [`../SKILL.md`](../SKILL.md) judge the design; this file defines the artifact.

Do not implement unless the user also asked for implementation. Inspect the codebase instead of asking questions it can answer. Keep unresolved product or architectural decisions explicit rather than inventing them.

## Ground the design

State only the context that changes the design:

- current behavior and problem;
- callers and affected entrypoints;
- constraints, invariants, and non-goals;
- runtime or operational requirements;
- open questions that block a concrete contract.

Every claim must come from the request, repository, verified dependency guidance, or an identified assumption.

## Define contracts in code

Use actual proposed TypeScript declarations in the repository's vocabulary. Show only new or changed domain values, states, inputs, outputs, failures, interfaces, and boundary projections.

Code defines the contract. Prose explains invariants, ownership, and tradeoffs that the declarations cannot express. Do not use decorative meta-types to summarize the design.

## Trace behavior

For each changed caller-visible behavior, lead with its actual proposed signature and trace the call stack from entrypoint to result. Include parsing, authorization, state transitions, side effects, failure translation, transactions, retries, cancellation, and projection when reachable.

Show current and proposed flow only when their difference explains the change. Every call-stack step must map to a proposed contract, existing symbol, or explicit open question.

## Assign ownership

Map each changed contract, invariant, policy decision, and technology translation to its owning module and file. Apply the alternative and depth tests in [`MODULES.md`](MODULES.md) before adding a consequential interface or seam.

List files only when their ownership or change is understood. Do not invent a file tree to make the design appear complete.

## Define proof

Apply [`TESTING.md`](TESTING.md). Name the observable proof for each changed behavior, invariant, expected failure, and public type contract.

## Output

Use only the sections the design needs:

1. Context, constraints, and non-goals.
2. Proposed TypeScript contracts.
3. Call stacks and failure flows.
4. Ownership and affected files.
5. Consequential alternatives and tradeoffs.
6. Proof plan.
7. Risks and open questions.

**Complete when:** implementation can begin without inventing domain states, boundary contracts, ownership, failure flow, or proof strategy.
