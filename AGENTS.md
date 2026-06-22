# AGENTS.md

## Style

- Be obsessed about organization, clarity and readability.
- Be concise in your communication and highly optimized for human readability. Your texts should be easy to follow and understand.
- Use technical language when needed but don't overuse it, they key is not to show how much you know, the key is that reader understands you easily.
- Use numbered questions when asking more than one thing.
- At the end of each response add a TLDR section that in one phrase summarizes all the response.

## Code

- Optimize for reviewability: small ordered diffs, obvious intent, no unrelated churn.
- Make code easy to follow, reason about, and test. Prefer boring, explicit flow over clever tricks.
- Prefer clear names: `kebab-case` files, `camelCase` values, `PascalCase` types.
- Prefer concept-named files over generic names like `utils.ts`, `helpers.ts`, or `misc.ts`.
- Prefer short single-word names for locals, params, and helpers when clear: `pid`, `cfg`, `err`, `opts`, `dir`, `root`, `child`, `state`, `timeout`.
- Use multi-word names only when a single word would be unclear or ambiguous.
- Create new files when code has a separate responsibility, is reused, or makes the current file hard to scan.
- Do not create barrel files like `index.ts` unless there is a strong package-entrypoint reason.
- Prefer explicit imports from the owning module instead of re-export chains.
- Promote reusable project concepts into existing shared places like helpers, components, services, or types. Do not create abstractions for one-off code.
- Keep types close to where they are used until shared by unrelated code.
- Validate inputs at boundaries.
- Comments explain why, not what. Include them when helpful for the reader.
- Place tests next to the behavior they cover.
- Test behavior through the public or intended caller-facing seam, not implementation details. Avoid mocks when practical.
- Name test groups by behavior/domain unless the function itself is the public API under test.
- Prefer small tests with clear behavior names.
- Use the test runner already used by the package/project.
- When you see code that doesn't follow our patterns, add a **Refactor Proposal** with why and a prompt to fix it later.

## Functional style

- Keep core logic pure. Push side effects to the edges: IO, network, DB, filesystem, UI handlers.
- Prefer dependency injection. Depend on interfaces/contracts, not concrete implementations.
- Prefer `const`, early returns, and ternaries over reassignment and `else`.
- Prefer functional array methods like `map`, `filter`, and `flatMap` over loops when they stay readable.
- Use type guards with `filter` when needed to preserve inference.
- Treat expected/domain failures as typed results, not thrown exceptions; suggest `better-result` unless the project already uses another result/effect library.
- Reserve `throw`/`try/catch` for unexpected failures or external boundaries.
- Prefer structured domain errors with stable codes and useful context.
