---
name: build
description: The workflow for every code change, from intake to a reviewed stack ready to land. Use when asked to add, change, fix, or refactor code, from a one-line fix to a large feature, and when resuming such work.
metadata:
  family: workflow
---

# Build

Every code change runs the same backbone; its track sets how many steps and gates it gets. The quality bar never scales down, only the ceremony.

A **slice** is the smallest change in behavior someone can observe and verify. Each slice is one change in version control, optionally preceded by a tidy-first change that only restructures, proved by the existing checks passing unchanged.

## 1. Intake

| | One slice, nothing open | More than one slice, or an open question |
| --- | --- | --- |
| **Build:** intent to behavior (a refactor's behavior is "unchanged") | small feature | big feature |
| **Fix:** symptom to cause | small fix | big fix |

A change has **stakes** when it touches authentication or permissions, data or migrations, money, a public API, or deletes anything. Stakes add the steps under Stakes; they don't change the track.

Announce the track in one line, then proceed: `Track: small fix · plan: none · gates: final review`. The user may overrule it.

Done when the track is announced.

## 2. Understand

| Track | Do | Result |
| --- | --- | --- |
| small feature | Read the nearest existing example of the same kind | The change's subject and its proof |
| small fix | Reproduce the failure | The failure, happening on demand |
| big feature | The `shape-feature` skill | The plan's Contract |
| big fix | The `diagnose` skill | The plan's Diagnosis |

Plans follow [`references/plan.md`](references/plan.md).

Done when the result in the table exists.

## 3. Design (big tracks)

Write the plan's Shape and Slices: the types and call stacks, judged by the `type-driven-development` skill, and each slice's proof, chosen with the `audit-tests` skill.

Done when every slice has a behavior and a proof, and every decision it needs is made or listed as open.

## 4. Gate 1: the plan (big tracks)

Stop and present the plan: its slices and their proof, the key types, the decisions, and the open questions. Write no product code before the user approves it.

Done when the user has approved the plan.

## 5. Slices

For each slice, in order:

1. Start its change with the description first (the `jj` skill). The subject states the slice's behavior.
2. Explore freely in `*.scratch.*` files, which never land. If the repository doesn't ignore that pattern, ask before adding it to `.gitignore`.
3. Write the code, and any test the slice's proof calls for, judged by the `type-driven-development` skill and the stack's own skills.
4. Run the slice's proof, using the project's verify skill when it has one.

Done when the slice's proof passes and its change holds only that slice.

**Escalate, never drift.** When a small track needs a second slice or a question opens, stop, say `upgrading to big <feature|fix>`, and return to step 2. When reality contradicts an approved plan, stop, update the plan, and ask.

Between gates, record each assumption for the review packet instead of asking.

The last change of the pull request that lands the final slice deletes the plan and moves what stays true into the project's docs, by the `write-docs` skill.

## 6. Review

Run the `review-diff` skill over the whole stack.

Done when its deliverable exists.

## 7. Gate 2: the stack

Write the review packet from [`references/pr.md`](references/pr.md) and stop. Push and open the pull request only when the user says so (the `jj` skill's landing). Answer each line comment, from review or the `plannotator-review` skill, with a fix in the change it concerns or a reason.

Done when the packet is presented or, once approved, the pull request URL is reported.

## Stakes

- Read the official docs for the installed versions of the libraries involved, and record every decision in the plan: who may do what, what expires, and what cannot be undone.
- Prove each forbidden actor and state is rejected, with a negative test.
- Land schema and data changes as their own reversible slice, before the code that needs them.
- Give the fresh reviewer the plan's decisions, and ask it for a security pass.
- Nothing merges without the user.

## Unattended runs

Only when the user grants one for an approved plan and the project has a verify skill. Run every slice through step 6 without stopping, then push the bookmark and open the pull request at gate 2, but never merge. Stop instead when a stakes decision is missing from the plan, when a proof fails and you can't fix it, or on a conflict.
