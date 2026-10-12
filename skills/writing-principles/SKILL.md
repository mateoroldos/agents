---
name: writing-principles
description: How we judge written text: where each piece belongs, and what to cut. Use when writing or editing a README, AGENTS.md, CLAUDE.md, a docs page, an ADR, an issue, a plan, a pull request or commit description, or a code comment, and when recording what a task taught you.
---

# Writing Principles

A line earns its place by changing what one reader does or knows, in the one place that reader looks. Every other line costs that reader and rots.

## One home

Give each piece of content one home, or none.

| Content | Reader | Home |
| --- | --- | --- |
| What it is, why use it, how to install and run it | a newcomer | README |
| A command, convention, or gotcha an agent can't find by looking | an agent on most tasks here | AGENTS.md |
| A recurring judgment or procedure | an agent on some tasks | a skill |
| An invariant, contract, or workaround the code can't express | whoever edits that code | a comment beside it |
| Why a hard-to-reverse choice was made, and what lost | a future maintainer | an ADR, if the project keeps them |
| What a feature delivers and what is decided, before it starts | the user choosing what's next | its issue |
| Decisions and the pull request path while a feature is built | the user and agents building it | its plan |
| What this change did, what was tried, how the task went | this change's reviewer | the commit or pull request description |
| What the code, config, `--help`, or file tree already says | nobody | nowhere |

- **Why:** two homes drift apart, and the reader trusts the wrong one.
- **Smell:** the same fact in an issue and a plan; a doc that copies a command's `--help`.

## No history

State the result as if it had always been true. Never write what you fixed, tried, or changed, or "now", "new", "previously", "no longer", "updated". Rewrite the line that became false instead of appending a correction.

- **Why:** version control holds history; a doc that tells it goes stale at the next change.
- **Smell:** "we changed X to Y"; an "Update:" paragraph below the line it corrects.

## No cache

Point to the file, script, or command instead of copying what it says. Copy only what is costly to look up: the unwritten convention, the reason, the gotcha.

- **Why:** a copy goes stale the day its source changes.
- **Smell:** a pasted config block, an export list, a restated function signature.

## Match the doc

Use the doc's headings, voice, and terms, and the project's names for things. A README stays a README; explanation goes behind a link.

- **Why:** a reader finds things where that kind of doc keeps them.
- **Smell:** a synonym for a name the project already uses.

## Show, don't narrate

A command, table, tree, diff, or signature beats the paragraph that describes it.

- **Why:** structure is scanned; prose has to be read.
- **Smell:** a paragraph listing options that share criteria.

## Cut slop

Read each sentence alone, and delete it if the reader would act the same without it; delete whole sentences rather than trimming words.

| Slop | Fix |
| --- | --- |
| Filler: "note that", "it's important to", "in order to", "simply", "basically" | Delete |
| Puffery: "robust", "seamless", "powerful", "comprehensive", "crucial" | Delete, or give the number |
| "Serves as", "features", "boasts" | "is", "has" |
| "Not just X, but Y"; forced groups of three | State the point once |
| A trailing "-ing" clause: "…, ensuring consistency" | Delete, or make it its own claim |
| Hedging: "may potentially", "generally tends to" | Commit, or name the condition |
| Status marks other than ✅ and ⚠️; bold or a heading on prose nobody scans | Delete |
| An intro that says what the doc will cover; a closing summary | Delete |
| A sentence that fits any project unchanged | Delete |

- **Why:** each slop line costs the reader attention and teaches them to skim.
- **Check:** `bash ~/agents/skills/writing-principles/scripts/slop.sh <files>` catches part of this table.
