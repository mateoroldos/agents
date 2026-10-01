---
name: build
description: Implement the next pull request once its approach is settled. Use when asked to implement, proceed, build, fix, or refactor, or to apply review comments, after the design is approved or the change copies a precedent.
---

# Build

Load the `delivery-principles`, `type-driven-development`, `testing-principles`, and `writing-principles` skills, and the stack's patterns, before writing code, tests, or docs.

1. **Write the smallest releasable change** the approved design or precedent describes.
2. **Prove it** with the cheapest proof that would fail without the change, and run it. Use the browser only when the UI changed.
3. **Cut:** read your whole diff and delete what the change doesn't need.

   Done when the checks pass and every line is needed. Then hand off to the `review-diff` skill.

**Stop at a guess.** Any choice the design didn't make goes back to the `plan` skill. When reality contradicts the plan, stop, update it, and ask. Record what you chose alone under Assumed.
