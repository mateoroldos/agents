---
name: plan
description: Decide what to build next and how, before any code. Use when work arrives or resumes, when asking what's next or where we are, when scope isn't agreed, when no precedent fits, when a bug isn't understood, and when asked to explore alternatives, compare designs, or step back.
---

# Plan

Load the `delivery-principles`, `type-driven-development`, and `testing-principles` skills, the tracker's pattern (the `github` skill), and the stack's patterns. Change only the issue, the plan, and `*.scratch.*` files, which never land. Open every answer with the `delivery-principles` status block.

1. **Read what exists:** the epic, the issue, the plan, and the code involved. Their decisions stand. Answer from the repository; never ask what it already says.
2. **What**, only when the issue isn't agreed: ask the budget first, then one question at a time with your recommendation, only what changes scope or what users see. Weigh not building it. Write the issue. Work over budget becomes an epic of issues in delivery order; plan only the first.
3. **Which pull request:** list them in the plan when there's more than one, and pick the next. When a precedent you opened fits, name it as `precedent <path>` and skip step 4.
4. **How**, only when no precedent fits: the precedent in this repository, then in reference repositories (the `repo-librarian` skill), then the official docs for the installed versions. For a bug, reproduce it first, as [`references/diagnose.md`](references/diagnose.md) describes. Weigh two or three alternatives, the simplest among them, each with its cost in code, tests, and concepts. Recommend one with the criterion that decides it, and write the plan's Design section.

   Done when the user approves the what and the how. Then hand off to the `build` skill.

A guarantee beyond the library's defaults goes to the user as a choice with its cost. When the user pushes back, re-judge by the same criterion; change your recommendation only for new evidence, and name it.
