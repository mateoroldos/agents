---
name: ship
description: Open, update, and land a pull request. Use when asked to open or submit a pull request, push, update its description, or merge, and after the user merges one.
---

# Ship

Load the `delivery-principles` skill, and the patterns for version control and the tracker (the `jj` and `github` skills). Open the answer that opens a pull request, and the one after its merge, with the `delivery-principles` status block.

1. **Open it:** push, write the description from the `delivery-principles` PR template, and mark it as needing the user.
2. **Answer review:** each comment through the `review-diff` skill, then a fix pushed on top or a reason.
3. **After the user merges:** sync with trunk. The next pull request's first change marks this one `✅ #<pr>` in the plan and folds its Design into Decided.

   While it waits, you may plan the next pull request; change no files.

   Done when trunk holds the merge. Then hand off to the `plan` skill for the next pull request.

The last pull request deletes the plan, moves its Decided lines into the project's docs, and closes the issue, and the epic when it was the epic's last issue.
