# Auditing a test suite

For an existing suite, and only when asked.

1. Read the project's AGENTS.md files, then each candidate test in full, with its production owner, the owner's callers, and overlapping tests. Change nothing yet.
2. For each candidate, record where it is, what failure it can detect, the stronger proof that remains (or why none is needed), and the test-only seam or dead code its removal unlocks. A candidate with a missing field stays.
3. Remove or repair one owner boundary at a time, with the seams it unlocks. Add no replacement test that restates the removed one.
4. Run the owner's tests and the project's checks.

Done when the report lists production and test lines removed separately, and each suspicious test kept, with the reason.
