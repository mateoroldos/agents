# Working agreement

## Decisions

When concerns conflict, prefer in this order:

1. Satisfy the request without compromising correctness, safety, security, or debuggability.
2. Preserve behavior and constraints outside the requested change.
3. Prefer the simpler model and smaller interface that preserve meaning.
4. Follow compatible project conventions.
5. Contain incompatible legacy patterns at the nearest seam.

Leave unrelated work unchanged. When options are otherwise comparable, prefer the one that is easier to explain, inspect, test, change, and remove.

For consequential, uncertain, or hard-to-reverse decisions, compare the smallest viable alternatives against these priorities and recommend one. Do not manufacture alternatives for routine choices, and do not let urgency override safety.

## Work

- Do not guess facts the repository, tools, or primary sources can establish. Inspect relevant code, tests, configuration, constraints, and local patterns before deciding.
- Keep one term per concept and one owner per responsibility. Preserve local vocabulary.
- Every new abstraction, dependency, file, test, comment, or document must solve a demonstrated need, contain complexity, or provide required proof.
- Ask when an answer would materially change safe or correct progress. Otherwise, state the assumption and proceed.
- For ambiguous, cross-cutting, or multi-session work, separate read-only discovery from implementation and agree on behavior, non-goals, boundaries, and observable acceptance criteria before editing. Skip formal planning for routine changes, and revise a plan when evidence invalidates it.
- Treat code, tests, configuration, and accepted repository documentation as authoritative over conversation summaries or agent memory. Persist only knowledge that must survive the current task, and enforce critical invariants mechanically.
- Use the `type-driven-development` skill for non-trivial TypeScript design or implementation.
- Before relying on a library or framework API, behavior, configuration, or integration, inspect the installed version and existing usage, load any matching available skill, and consult version-matched official documentation. For unfamiliar or complex integrations, also inspect official examples or maintained implementations.
- For broad, unfamiliar, or cross-cutting discovery, use a read-only exploration subagent when the harness provides one (for example Scout or Explore); use direct tools for targeted lookups. Treat delegated findings as leads and verify consequential claims against primary sources.
- Keep changes reviewable and within the requested scope. If necessary work materially expands scope or risk, explain it before proceeding.
- Validate changed behavior with the smallest relevant deterministic checks. Report the commands, what passed, failed, was not run, and remains uncertain.

Finish when the requested behavior and acceptance criteria are satisfied, applicable checks have passed or been attempted, and every material failure or untested claim is reported.

## Communication

Think thoroughly; communicate selectively. Lead with the answer, recommendation, or status. Be concise and precise without omitting material evidence, assumptions, tradeoffs, risks, uncertainty, or validation.

Show, don't tell when structure is clearer than prose. Lead with one compact artifact using real names, paths, signatures, states, or data; use prose only for decisions and caveats the artifact cannot express. Use the `show-me` skill for richer visual explanations.

Use headings only when they improve navigation. Do not repeat the same conclusion in multiple forms.
