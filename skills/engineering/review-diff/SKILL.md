---
name: review-diff
description: Review your own diff before a human sees it, cutting slop and test slop and then getting a fresh reviewer's findings. Use before presenting, pushing, or opening a pull request for a code change, or when asked to clean up or self-review a diff.
metadata:
  family: workflow
---

# Review the Diff

Every line the human reviews must be there because the change needs it. Review only the lines this change adds or modifies; report problems in older code without fixing them.

## 1. Read the whole diff

The base is trunk, or the top of the unmerged pull request below this one. Read every hunk of `jj diff --from <base> --to @`, or `git diff $(git merge-base HEAD <base>)` without jj.

Done when every changed file has been read, not only the ones you remember touching.

## 2. Run the machine checks

Run the project's lint, typecheck, and unused-code checks.

Done when they pass with no new warnings, or each failure is reported.

## 3. Cut slop

| Slop | Fix |
| --- | --- |
| Dead code: an unused symbol, parameter, import, or export; an unreachable branch; commented-out code; debug output or temporary instrumentation | Delete |
| A comment that narrates the code or the edit instead of carrying information, as the `type-driven-development` skill defines it | Delete |
| A doc or skill line that narrates the change, copies what the code says, or reads as slop, as the `write-docs` skill defines it | Delete |
| A module, wrapper, option, or seam that fails the deletion test of the `type-driven-development` skill | Inline or delete |
| A change the task did not need: a drive-by refactor, formatting churn, a new dependency, a speculative option | Revert it, or move it to its own change and report it |
| A second representation of the same thing | Keep one |

Fix each finding in the change that introduced it (see the `jj` skill).

Done when every added line is needed by the change.

## 4. Cut test slop

Put every added or changed test through the gate of the `audit-tests` skill, and delete or promote each `*.scratch.*` file you created.

Done when every landed test passes the gate.

## 5. Get a fresh review

A reviewer who didn't write the code sees what the author is blind to. Prefer a different model: run `codex review --base <base-branch>` when Codex is installed; with jj, run it while `@` is empty so git's HEAD is the top of the stack. Otherwise give a fresh subagent only the diff, the intent (the plan or the change descriptions), and the project's AGENTS.md, and ask it for defects, not style.

Fix each finding in the change that owns it, or answer it with a reason.

Done when every finding is fixed or answered.

## Deliverable

For the pull request description: each reviewer finding with its outcome (fixed, or answered with the reason).
