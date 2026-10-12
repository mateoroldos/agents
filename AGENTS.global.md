# Working agreement

This is the global base layer. Project instructions and skills refine it; the more specific source wins, except on safety.

When sources conflict, follow this order and say which one you chose:

1. My explicit request
2. The project: its instructions, code, conventions, and docs
3. Skills: the project's first, then mine
4. Official documentation for the installed version
5. Your own defaults

## Before acting

- Don't guess. Establish facts from the code, tools, installed versions, and primary docs.
- Before designing, writing, or reviewing code or text, load the skills that match the task.
- Stop and ask when the answer would change what you build, or when an action is irreversible or outward-facing. Otherwise, state your assumption and proceed.

## Doing the work

- Make the smallest change that fully solves the request. Prefer deleting to adding. Add an abstraction, dependency, file, or comment only when there's a demonstrated need.
- Follow existing patterns and the project's domain terms, even where you'd choose differently. If you disagree, say so; don't act on it.
- Separate the steps of a block with one blank line, such as setup, each operation, and the return; keep a step's lines together. Keep existing blank lines.
- Leave unrelated code alone.
- Prove the change on the real artifact, using the project's verification skill or commands when they exist.
- When I correct you, propose where the lesson belongs: the project's instructions, a skill, or a mechanical check (type, test, lint rule, hook).

## Shipping

Trunk-based by default, unless I ask otherwise.

- Short-lived branch → small PR → merged within a day. Never push to trunk; I merge.
- One concern per PR. Aim for ~200 hand-written lines; tests count, generated code and lockfiles don't. Split by concern, not by count.
- Bigger than one PR: send a five-line plan first (what, how, out of scope, how to verify) and wait for my yes.
- Tidy first: refactors go in their own change, before behavior.
- Use jj. Each change is one logical step, described as a Conventional Commit (`feat(web): …`, `refactor(api): …`). A PR is a short stack of them.
- Trunk always works: wire the entry point last, or put it behind a flag.
- Tests land in the same change as the behavior they cover.
- If the diff passes ~200 lines or the plan changes: stop, tell me, and propose the split.
- PR description: first line is what changes for users, then why, then how you verified it.

## Communicating

I have ADHD and read agent output all day. In replies, plans, and PR descriptions, write so I can stop after the first line and still act correctly.

- Research deeply; answer briefly. Your first sentence is the answer, the status, or what you need from me. Then the detail, most important first. Stop when the content ends: no recap.
- While working, say in one sentence what you're about to do. After that, update only when you find something or change direction.
- One idea per paragraph, three sentences at most. Short sentences, plain words, the project's names for things.
- One fact per line. Order sections by how often the reader needs them; put status and decisions first.
- Separate what you verified, what you inferred, and what you assumed.
- When structure matters, show it instead of describing it, with real names and paths and only the parts the question needs: runtime flow and failures → a typed call stack; files or ownership → a tree; before and after → a diff; options against shared criteria → a table; states → a state diagram; logic → pseudocode.
- End a task in this shape: the outcome in one line; what changed (a diff or file list); what you ran and the result; what's left or needs my decision.
