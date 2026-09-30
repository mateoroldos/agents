---
name: write-docs
description: Put documentation in its one right home and write it with no slop. Use when creating or editing a README, AGENTS.md, CLAUDE.md, a docs page, an ADR, a changelog, or a code comment, and when recording what a task taught you.
metadata:
  family: workflow
---

# Write Docs

A doc states what is true, for one reader, in the one place that reader looks. Every other line costs that reader and rots.

## 1. Route

Give each piece of content one home, or none.

| Content | Reader | Home |
| --- | --- | --- |
| What it is, why use it, how to install and run it | a newcomer | README |
| A command, convention, or gotcha an agent can't find by looking | an agent on most tasks here | AGENTS.md |
| A recurring judgment or procedure | an agent on some tasks | a skill, by the `write-skill` skill |
| An invariant, contract, or workaround the code can't express | whoever edits that code | a comment beside it |
| Why a hard-to-reverse choice was made, and what lost | a future maintainer | an ADR, if the project keeps them |
| What this change did, what was tried, how the task went | this change's reviewer | the commit or PR description |
| What the code, config, `--help`, or file tree already says | nobody | nowhere |

Done when every piece has a row, and nothing sits in a home whose reader doesn't need it.

## 2. Write

- **No history.** State the result as if it had always been true. Never write what you fixed, tried, or changed, or "now", "new", "previously", "no longer", "updated". Version control holds history.
- **No cache.** Point to the file, script, or command instead of copying what it says. Copy only what is costly to look up: the unwritten convention, the reason, the gotcha.
- **Edit in place.** Rewrite the line that became false; don't append a correction or a new section beside it.
- **Match the doc.** Use its headings, voice, and terms. A README stays a README; explanation goes behind a link.
- **Show, don't narrate.** A command, table, tree, or signature beats the paragraph that describes it.

Done when every added line is true at this commit and lives nowhere else.

## 3. Cut

Read each added sentence alone. Delete it if the reader would act the same without it; delete whole sentences rather than trimming words.

Run `bash ~/agents/skills/engineering/write-docs/scripts/slop.sh <files>` and fix each hit, then scan for these patterns, which it catches only in part:

| Slop | Fix |
| --- | --- |
| Filler: "note that", "it's important to", "in order to", "simply", "basically" | Delete |
| Puffery: "robust", "seamless", "powerful", "comprehensive", "crucial" | Delete, or give the number |
| "Serves as", "features", "boasts" | "is", "has" |
| "Not just X, but Y"; forced groups of three | State the point once |
| A trailing "-ing" clause: "…, ensuring consistency" | Delete, or make it its own claim |
| Hedging: "may potentially", "generally tends to" | Commit, or name the condition |
| Bold labels, emoji, or a heading on every short paragraph | Plain prose or one list |
| An intro that says what the doc will cover; a closing summary | Delete |
| A synonym for a name the project already uses | The project's name |
| A sentence that fits any project unchanged | Delete |

Done when the script is clean and every remaining sentence changes what the reader does or knows.

## Deliverable

The diff, with lines added and removed per file, and each piece of content you routed elsewhere or dropped.
