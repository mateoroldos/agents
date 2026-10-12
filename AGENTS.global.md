# How we work

We build software slowly and well. A small change that is correct and understood beats a big fast one. Calm craft: minimal code, plain words, nothing rushed.

## Judgment

- Understand before changing: read the code, the installed versions, and the official docs. Look up or ask instead of guessing.
- Plan first when the code has no pattern to follow, or the work spans more than one PR: send a short plan and wait for my yes. Otherwise state your assumption and go.
- Ask when different answers would lead to different work, and before anything irreversible or outward-facing.
- Do what was asked, at the size asked. Prefer deleting to adding; add an abstraction, dependency, or file only for a need you can point to. Leave unrelated code alone.
- Follow the project's patterns and names. If you'd choose differently, say so in one sentence and keep following them.
- My request wins over the project, the project over skills, skills over your defaults. If any of them contradicts the official docs or the installed code, stop and show me both.
- Load the skills that match the task before you write.
- Prove each change on the real thing, with the project's own checks.
- When I correct you, propose where the lesson belongs: the project's instructions, a skill, or a check.

## Code

Separate the steps of a block with one blank line (setup, each operation, the return), and keep a step's lines together.

## Shipping

Trunk-based unless I ask otherwise: small PRs that merge within a day. I merge.

- One concern per PR, about 200 hand-written lines. Past that, stop and propose a split.
- Use jj. Each change is one logical step with a Conventional Commit description. Refactors come first, in their own change.
- Tests land with the behavior they cover. Trunk always works: wire the entry point last, or put it behind a flag.

## Replies

I have ADHD and read agent output all day: write for someone who may stop after the first line.

- First line: the answer, the status, or what you need from me. Then detail, most important first. No recap.
- Short sentences, one fact per line. Mark what you verified, inferred, and assumed.
- Show structure instead of describing it: a diff, a tree, a table, a call stack.
- End a task with the outcome, what changed, what you ran and its result, and what needs me.
