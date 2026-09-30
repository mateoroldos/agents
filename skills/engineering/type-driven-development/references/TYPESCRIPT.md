# TypeScript

Use TypeScript to check claims, not to decorate JavaScript.

## Let inference work

- Annotate module interfaces and public contracts where the type explains the design.
- Let local implementation details infer when the result stays clear.
- Use `satisfies` to check a value without widening or lying.
- Use `as const` to preserve literals.
- Keep type-only dependencies explicit with `import type` and `export type`.

Avoid redundant annotations that can drift from the implementation.

## Do not silence evidence

Avoid `any`, non-null assertions, and unchecked `as Type` casts. Parse, branch, narrow, or improve the type instead. Wrap a third-party `any` immediately so it cannot spread.

TypeScript types disappear at runtime. External, persisted, deserialized, and third-party values remain `unknown` until runtime parsing succeeds. A cast changes the compiler's belief; it does not inspect the value.

A rare cast at an interop or generic boundary requires a local proof:

```ts
// SAFETY: parseEmail checked and normalized the value; TypeScript cannot express this brand.
return normalized as EmailAddress
```

The comment states the invariant already established and why TypeScript cannot represent it.

## Prefer precise compiler settings

Enable where compatible:

```json
{
  "compilerOptions": {
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "noImplicitOverride": true,
    "noFallthroughCasesInSwitch": true
  }
}
```

Do not flip stricter settings mechanically in an existing project without auditing the resulting semantic changes.

## Keep mutation local

Prefer readonly values and immutable interfaces. Mutation is acceptable inside a performance-sensitive implementation, builder, stateful adapter, or imperative shell when the module hides it behind a precise interface.

## Preserve module identity

- Import from the file that owns the concept.
- Use a namespace import when it makes a domain module read as one concept: `EmailAddress.parse(input)`.
- Avoid TypeScript `namespace` declarations for organization.
- Export only intentional caller surface; do not export internals for tests.
- Avoid generic barrel layers that obscure ownership or create cycles.

Do not impose arbitrary file-size limits. Split when code has unrelated reasons to change or callers must learn unrelated concepts.

## Write comments that carry information

Document invariants, contracts, tradeoffs, safety arguments, surprising runtime constraints, and non-obvious public library surfaces. Do not require JSDoc on every export or narrate the next line of code.

Preserve explanatory comments until their claim has been verified obsolete. A comment describing a compiler, bundler, platform, or compatibility workaround is evidence, not cleanup bait.
