---
name: ts-standards
description: TypeScript standards for new TS code, reviews, refactors, adapters, tests, errors, schemas, domain types, module shape, and public API documentation. Use whenever creating, editing, or reviewing TypeScript.
---

# TypeScript Standards

Use this skill to keep TypeScript code **correct by construction**: parse at boundaries, make invalid states unrepresentable, return expected failures as values, and preserve the project's existing architecture.

## Operating rule

Before adding a pattern, library, adapter, service, or abstraction, inspect the local code first. Prefer the repo convention unless it conflicts with safety, correctness, or debuggability.

Priority order:

1. Preserve correctness, safety, and debuggability.
2. Follow established project architecture and conventions.
3. Improve the local design toward these standards.
4. Avoid broad migrations unless explicitly requested.
5. Document meaningful trade-offs with comments or ADRs.

## Workflow

1. **Survey the local convention**
   - Check existing error handling, schemas, dependency injection, tests, observability, adapters/services, and module layout.
   - Completion: the new code has a named local convention to follow, or a reason to diverge.

2. **Find the domain types and seams**
   - Look for existing domain modules, branded/refined types, parsers, smart constructors, services, and adapters before creating new ones.
   - Completion: every new or modified concept either reuses an existing owner or has a clear owning module.

3. **Design the boundary**
   - Parse `unknown` / DTO / framework input into domain values early.
   - Translate framework, library, and infrastructure failures into local typed errors at the edge.
   - Completion: core/application code receives refined values, not raw DTOs, raw IDs, nullable bags, or `Partial<T>` unless those are the domain concept.

4. **Model expected failures as values**
   - Use Effect errors in Effect codebases, `better-result` when established, or a small local tagged `Result` union.
   - Reserve `throw` / rejection for defects, impossible branches, startup misconfiguration, or framework-required behavior.
   - Completion: every expected domain, parsing, authorization, integration, I/O, persistence, and workflow failure appears in the return type.

5. **Shape modules for leverage**
   - Prefer deep cohesive modules and narrow dependency shapes.
   - Audit existing adapters/services before creating a new one.
   - Completion: callers depend on the smallest meaningful interface, and any meaningful new adapter/service has reuse/extension considered.

6. **Test through real seams**
   - Prefer e2e for critical flows, integration tests through real seams, focused/property tests for pure domain modules, and unit tests only for meaningful behavior.
   - Do not use `vi.mock` / `jest.mock` for module mocking; use injected interfaces/classes, Effect layers, local DBs, in-memory adapters, or fake external adapters.
   - Completion: tests assert observable behavior: returned value/error, persisted state, emitted event/message, rendered response, or fake/local adapter output.

7. **Document the public surface**
   - Add JSDoc to exported functions, classes, methods, constants, and usually exported types.
   - Explain invariants, trade-offs, domain rules, and safety justifications; do not narrate obvious code.
   - Completion: exported symbols explain caller meaning, and expected typed errors are not documented as `@throws`.

## Boundary rules

- Use `parseX(input): Result<X, ParseXError>` for untrusted or less-structured input.
- Use `makeX` / `createX` for smart constructors from already-typed pieces.
- Use `isX(value): boolean` only for true predicates.
- Avoid `validateX` when returning a refined value; it parsed something.
- Use the repo's schema library; prefer Effect Schema in Effect codebases, Standard Schema compatibility for generic helpers, otherwise Zod 4 or hand-written parsers.
- Schema parsing should produce refined/domain types and typed custom errors where practical.

## Domain modeling rules

- Use branded/refined types for meaningful primitives: IDs, emails, URLs, non-empty strings, constrained numbers, units, money, durations, bytes.
- Construct branded values only through parsers or smart constructors.
- Push optionality outward; branch or parse before calling functions that require values.
- Avoid `Partial<T>` as application/domain input unless partiality is the domain concept.
- Model lifecycle states with tagged unions or equivalent value classes, not boolean flag clusters.
- Avoid boolean behavior parameters; use named options or domain types. Predicate booleans are fine.

## Error rules

- Custom expected errors need a stable tag, useful message, structured context, safe telemetry fields, and optional `cause: unknown`.
- Keep error unions precise at module boundaries; avoid broad `AppError` types except near entrypoints, orchestration, logging, and rendering layers.
- Use existing `prelude.ts` helpers when available: `casesHandled`, `shouldNeverHappen`, `notYetImplemented`, `Redacted`.
- Use `casesHandled` for exhaustive union handling; do not add one-off `assertNever` helpers when a project helper exists.

## Adapter and persistence rules

- Depend on the smallest meaningful shape a module actually uses; concrete adapters may be wider.
- Reuse an existing adapter as-is when possible.
- Extend an existing adapter only when the method fits the same cohesive capability and reason to change.
- Create a new adapter only when reuse/extension would create bad coupling or an accidental interface.
- For meaningful new adapters/services, add an ADR covering what was checked, why reuse/extension did not fit, and why the new capability is cohesive.
- Avoid repository-per-table by default. Persistence adapters expose domain operations and typed errors, not raw rows or ORM errors.
- Keep SQL/ORM row shapes inside infrastructure; parse rows before application/core logic.

## Functional core / imperative shell

- Keep domain logic, parsers, state transitions, combinators, and decision functions pure.
- Keep I/O, persistence, HTTP, queues, telemetry, time, randomness, and failure classification in the shell.
- Keep entrypoints thin: parse protocol input, invoke shared modules, render protocol output.
- Put authorization policy in shared application/domain code; entrypoints authenticate and pass parsed authorization values.
- Use durable workflows/sagas when work needs retries, compensation, idempotency, resumability, timers, human approval, cross-service coordination, or multiple transaction boundaries.
- Retriable commands/jobs/workflow steps need an explicit idempotency strategy.

## TypeScript safety rules

- Prefer strict settings where practical: `strict`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitOverride`, `noFallthroughCasesInSwitch`.
- Prefer immutable values: `readonly` fields and `ReadonlyArray`.
- Avoid `any`, non-null assertions, and non-`as const` casts.
- Never use `!`; branch, parse, or refine instead.
- Rare casts require a Rust-like `SAFETY:` comment explaining the invariant and why TypeScript cannot express it.
- Rare `any` requires a targeted lint ignore plus `SAFETY:` justification.

## Imports, exports, and files

- Import directly from the file that owns the abstraction; avoid barrel files by default.
- For domain modules, namespace imports often preserve shape: `import * as EmailAddress from "./email-address"`.
- Use named imports for classes, prelude helpers, and focused shared helpers.
- Use `import type` / `export type` for type-only imports and exports.
- Export only caller-facing symbols; do not export internals just for tests.
- Avoid vague files like `utils.ts`, `helpers.ts`, `common.ts`, `misc.ts`; use concept names.
- `prelude.ts` is only for tiny ubiquitous helpers/types, not domain/application policy.
- Split files by cohesion and reasons to change, not arbitrary size limits.

## Sensitive data and resources

- Do not put secrets in errors, traces, logs, or snapshots.
- Wrap tokens, API keys, passwords, raw credentials, and secrets in `Redacted<T>` at the boundary; unwrap only inside adapters that need raw values.
- Parse environment/config at startup into typed config with branded/redacted values where appropriate.
- Do not read `process.env` throughout the app.
- Avoid top-level side effects except in true entrypoint/bootstrap files.
- Make resource creation and cleanup explicit, or own them through Effect layers.
- Avoid mutable singletons/global state unless isolated at a framework/runtime boundary.
- Inject `Clock` / `Random`, or pass explicit `now` / random values into pure functions.

## Quick review checklist

- [ ] Local conventions were inspected before new patterns were added.
- [ ] Inputs are parsed at edges into domain types.
- [ ] Expected failures are typed values.
- [ ] Sensitive values are redacted and telemetry fields are safe.
- [ ] State is represented with domain types, not boolean/nullable bags.
- [ ] Modules are cohesive and deep; dependency shapes are narrow.
- [ ] Existing adapters/services were audited before adding new ones.
- [ ] Tests use real seams, not module mocks.
- [ ] Casts/`any` have `SAFETY:` justifications; `!` is absent.
- [ ] Exports have useful JSDoc.
