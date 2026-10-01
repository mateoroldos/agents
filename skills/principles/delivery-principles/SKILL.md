---
name: delivery-principles
description: How we judge the way work reaches trunk: where each decision lives, when to design, and how big a pull request is. Use when filing or shaping an issue or epic, writing or reading a plan, sizing or splitting work, or writing a pull request description.
---

# Delivery Principles

Work moves issue → plan → pull requests → trunk, and each step waits for the user's yes.

## Say where we are

Open planning and shipping answers with the status block in [`references/status.md`](references/status.md): the epic, the issue, the pull request, and what's next.

- **Why:** the user and the agent agree on which work this is before reading any detail.
- **Smell:** an answer the user reads to the end before knowing which pull request it's about.

## What, then how, then code

Agree what to build in the issue, then how in a design, then write code.

- **Why:** code written before its design is agreed gets rebuilt.
- **Smell:** a pull request reworked over its approach, not its details.

## Copy a precedent or design

A pull request copies a precedent you have opened, or it needs a design first.

- **Why:** an approach that seems obvious but has no precedent is the one that gets rebuilt.
- **Smell:** a plan row with no precedent path that went straight to code.

## The user owns scope and guarantees

Scope, what users see, and any guarantee beyond the library's defaults are the user's decisions. Propose each one with its cost.

- **Why:** an invented guarantee grows machinery nobody asked for.
- **Smell:** a rule in the plan that no one asked for, and the code built to enforce it.

## One home per decision

| Decision | Lives in |
| --- | --- |
| What, for whom, budget, product Decided | the issue: [`references/issue.md`](references/issue.md) |
| The pull requests, the next design, technical Decided | the plan, when there's a design or more than one pull request: [`references/plan.md`](references/plan.md) |
| Why, the overview, Assumed, proof | the pull request: [`references/pr.md`](references/pr.md) |
| What still holds after the last pull request | the project's docs |

- **Why:** a decision written twice drifts.
- **Smell:** the plan restating the issue, or the PR restating the plan.
- **Check:** `bash ~/agents/skills/principles/delivery-principles/scripts/plan-check.sh plans/<name>.md`.

## Detail only what's next

Shape only the next issue, and design only the next pull request.

- **Why:** later work changes once earlier work lands.
- **Smell:** a design for a pull request that isn't next.

## Trunk stays releasable

Every pull request leaves trunk working, with nothing half-built visible to users.

- Add the entry point last, or behind a flag when it must be tried early.
- Change a shared interface by adding the new one, moving callers, then removing the old.
- Land a schema change as its own pull request, first.
- **Why:** trunk is always the thing you could ship.
- **Smell:** a pull request that only works once the next one lands.

## Small, one at a time

A pull request is about 100 to 200 hand-written lines, never over 400; generated and vendored code doesn't count. Open the next only after the user merges the last.

- **Why:** a small pull request gets read; a large one gets skimmed.
- **Smell:** an issue over about eight pull requests; split it into issues of an epic.
