# Agents

Shared agent instructions and skills for Claude Code, Codex, opencode, and Pi.

## Usage

Run the sync script to link `AGENTS.global.md` and each skill into every supported tool. `AGENTS.md` holds instructions for working in this repo.

| Harness | Instructions | Skills |
| --- | --- | --- |
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/skills/<name>` |
| Codex, opencode, Pi | their own global `AGENTS.md` | `~/.agents/skills/<name>` |

Skills dirs hold one link per skill, so anything a harness writes there stays out of this repo.

```fish
./agents-sync.fish
```

Check that the repo is valid with:

```fish
./agents-doctor.fish
```

## Workflow

Each event skill fires at one moment in the work and stops at a gate:

```text
         ┌──────────── ship: merged → next pull request ────────────┐
         ▼                                                           │
 work ─▶ plan ──you approve──▶ build ──▶ review-diff ──▶ ship ───────┘
         ▲                       │
         └──────── a guess ──────┘
```

`plan` and `ship` open with a status block: the epic, the issue, the pull request, and what's next.

| Event | Fires when | May change |
| --- | --- | --- |
| `plan` | work arrives or resumes, "what's next?", no precedent fits, a bug isn't understood, or you ask for alternatives | the issue and the plan |
| `build` | the approach is settled | code |
| `review-diff` | a diff needs review, or review comments arrive | nothing, unless told |
| `ship` | a pull request opens, updates, or merges | the pull request |

Events load the principles (`delivery-principles`, `type-driven-development`, `testing-principles`, `writing-principles`, `design-engineering`); patterns apply them to a technology (`github`, `jj`, `effect-patterns`).

| Word | Means |
| --- | --- |
| precedent | existing code you opened and copy; without one, a pull request needs a design |
| budget | how many pull requests the work is worth, agreed before shaping it |
| Decided · Assumed | what the user approved · what the agent chose alone |
| ⚠️ Needs you | what waits on the user: the plan's alert and the `needs-you` label |

| Artifact | Holds | Gone when |
| --- | --- | --- |
| Epic | what people can do once all its issues close | its last issue closes |
| Issue | outcome, budget, Out of scope, product Decided | its last pull request merges; it keeps its decisions |
| `plans/<name>.md` | the pull requests, the next Design, technical Decided | its last pull request deletes it, moving Decided into docs |
| Pull request | why, Overview, Assumed, Read closely, Proof | merged |

## Skills

```text
skills/<level>/<name>/SKILL.md   owned: written and edited here
vendor/skills/<name>/SKILL.md    third-party: installed by the skills CLI, never edited; counts as a pattern
```

The level directory says what a skill is and which skills it may name: `events` · `principles` · `patterns` · `tools` (user-invoked) · `meta`. The `write-skill` skill defines each one.

Harnesses see one flat list: `agents-sync.fish` links every skill into each harness skills dir by name,
so names must be unique across levels. Skills refer to each other by name, never by relative path.

`ls skills/* vendor/skills` is the catalog. `agents-doctor.fish` fails when a skill sits outside a known level,
a tool is model-invoked, a vendored skill lacks a lock entry, a skill names one its level may not,
or a pattern names no principle or event.

Attribution for skills adapted from other developers: [CREDITS.md](CREDITS.md).

### Third-party skills

| Mode | When | Where |
| --- | --- | --- |
| Adopt | use it unchanged | `vendor/`, installed and updated by the skills CLI |
| Adapt | you want to change it | an owned level directory, plus a row in `CREDITS.md` |
| Try | one-off use | `npx skills use <owner>/<repo>@<skill>`, nothing installed |

`vendor/` is the [skills CLI](https://github.com/vercel-labs/skills)'s project: run it from there so it writes
`vendor/skills/` and `vendor/skills-lock.json`. `-a openclaw` is used only because its project skills directory
is `skills/`. Read the diff after every update: skills run with full agent permissions.

```fish
cd vendor
npx skills add <owner>/<repo> -s <skill> -a openclaw --copy   # install
npx skills update -p                                          # update
cd .. && ./agents-sync.fish
```
