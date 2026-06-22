---
name: code-comments
description: Code commenting standards for TS/JS public APIs, JSDoc, safety comments, deprecations, and non-obvious implementation notes. Use whenever adding or reviewing comments.
---

# Code Commenting

Document the **public API surface** clearly. Leave internals mostly silent unless the invariant, trade-off, workaround, or safety reason is not obvious from the code.

When the code is TypeScript, also apply the `ts-standards` skill.

## Rules

1. **Exported functions/types/classes/interfaces/constants** → JSDoc:
   - One-line description of *what it does* and *why it exists*.
   - `@param name - meaning` when parameters need caller-facing explanation.
   - `@returns - meaning` when the return value is not obvious from the name/signature.
   - `@example` with a realistic usage snippet for non-trivial call signatures.
   - `@deprecated`, `@see`, `@default`, `@throws` where relevant.
   - `@internal` for exports that exist for technical/cross-package reasons but aren't part of the public contract.

2. **Type/interface properties** → short `/** ... */` above each field describing its meaning, units, or default. This is what shows up in IDE autocomplete.

3. **Internal/private functions** → no JSDoc block by default. Add a plain `//` comment only to explain *non-obvious reasoning*: a workaround, perf trick, edge case, or "why this looks weird." Never restate what the code already says.

4. **Never duplicate the type system.** No `@param {string} name`, no `@returns {number}`. Types are inferred/checked by TS — comments add meaning, not redundant type info.

5. **Expected typed errors** are documented as return values, not `@throws`. Use `@throws` only for unrecoverable defects, framework-required behavior, or temporary `notYetImplemented` paths.

6. **Safety comments** are required for rare non-`as const` casts or `any` usage. Start with `SAFETY:` and state the checked invariant plus why TypeScript cannot express it.

7. **API stability tags** (`@public`, `@alpha`, `@beta`, `@experimental`) on exports whose stability isn't "stable public API" by default.

## Anti-patterns to strip out

- JSDoc blocks on every function "just because."
- `@param {Type} x - the x parameter` (no information added).
- Comments restating the next line of code (`// increment i` above `i++`).
- `@throws` for ordinary typed/domain failures returned as values.
- Missing `SAFETY:` justification on casts or rare `any`.
- Missing `@example` on exported hooks/functions with non-obvious call signatures.
- Undocumented `@deprecated` (always explain the replacement).

## Tooling note

- **TypeDoc**: generates a docs site from these comments — default choice for most libraries.
- **API Extractor**: for large monorepos needing `.d.ts` rollups and public-API diffing/governance — pairs with `@public`/`@internal` tags.
