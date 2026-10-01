---
name: review-diff
description: Review a diff and report what to fix, or answer review comments. Use before opening or updating a pull request, when asked to review a diff, change, or pull request, or check that it's ready to merge, and when the user pastes review comments.
---

# Review the Diff

Load the `type-driven-development`, `testing-principles`, and `writing-principles` skills, and the stack's patterns. Report; change nothing unless the diff is yours inside the `build` skill, or the user says to apply.

1. **Read it all:** every hunk of `jj diff --from 'trunk()'` (or git's from the merge base), and the plan's Design.
2. **Run the checks:** lint, typecheck, tests.
3. **Judge each added line:** defects first, then anything the change could do with less code, fewer tests, or shorter docs.
4. **Get one independent review** per pull request, skipped for docs-only changes: a fresh subagent, or the reviewer the project's AGENTS.md names, given only the diff, the intent, and AGENTS.md. Ask it for defects and anything that could be less.

   Done when every finding is listed with `file:line`, most severe first.

For review comments, answer each with evidence and a recommendation, and change nothing until told.
