---
name: audit-tests
description: Decide whether a test should exist, and prune the tests that shouldn't. Use when choosing how to prove a change, when writing, changing, or reviewing tests, or when asked to audit, prune, or clean up a test suite.
metadata:
  family: workflow
---

# Audit Tests

A test is code that pays for its upkeep only by catching a regression nothing else catches. The same bar applies to new tests (the gate) and existing ones (the audit).

## Choose the proof

Pick the cheapest proof that is enough; a new test is the last row, not the default.

| Proof | Enough when |
| --- | --- |
| Types | the compiler rules the failure out |
| An existing test | a test already owns this contract |
| The running app | the change is UI, copy, layout, or wiring best judged by using it |
| Review | config, renames, docs, one-off scripts, prototypes |
| A new test | a behavior or contract with a credible regression that nothing above catches |

## The gate

Before adding or changing a test, answer all four. A missing answer means no test.

1. **Behavior:** what observable behavior or contract does it protect?
2. **Regression:** what credible change to the code would make it fail?
3. **Owner:** why doesn't existing coverage catch that? Each contract has one primary test at the strongest boundary that exercises it; another layer gets a test only for a risk the owner can't reach. Extend a table or fixture instead of adding a near-duplicate.
4. **Seam:** does it need an export, flag, wrapper, or hook that no production caller needs? Then test at the real boundary instead.

Then check it against the junk patterns. A test that would break under a refactor that preserves behavior asserts implementation; rewrite it at the owning boundary.

A bug's regression test is the one test that must be seen failing: on the code before the fix, for the reported reason. One regression test at the owner boundary covers the bug; don't replay it at every layer it crosses.

Write each test that passes the gate as [`references/writing.md`](references/writing.md) describes.

Done when every added or changed test has its four answers and matches no junk pattern.

## Junk patterns

- **No oracle:** it runs the code but asserts nothing that could be wrong, such as `toBeDefined`, a `typeof` check, or "does not throw".
- **Borrowed answer:** the expected value comes from the code under test, or from a snapshot nobody checked. Expected values are literals worked out independently.
- **Restated guarantee:** it checks what the types, a library, or a declared flag already guarantee, instead of exercising what they promise.
- **Implementation:** it asserts private calls, call order that isn't observable, or that a mock was called; or its mock implements the behavior it asserts.
- **Duplicate:** another test already owns the contract, or a shared helper's test is replayed for each caller.
- **Copied source:** it greps for exact source text, imports, or export lists.
- **Seam keeper:** it exists only to keep a test-only export alive, or it tests dead code whose only callers are tests.
- **False negative:** a rejection test passes for the wrong reason, such as a different guard.
- **Overpromise:** its name claims more than its input exercises.
- **Fragile:** it sleeps to synchronize, or has loops and branches of its own.

## Keep bar

Keep a test that looks like implementation when it is the only guard of a public API, protocol, stored format or migration, security rule, config default, or observable ordering. Slow or static is not a reason to delete a test. A kept test that fails on untouched code may have found a product bug: reproduce it before changing the test.

## Audit mode

For an existing suite, and only when asked:

1. Read the project's AGENTS.md files, then each candidate test in full, with its production owner, the owner's callers, and overlapping tests. Change nothing yet.
2. For each candidate, record where it is, what failure it can detect, the stronger proof that remains (or why none is needed), and the test-only seam or dead code its removal unlocks. A candidate with a missing field stays.
3. Remove or repair one owner boundary at a time, with the seams it unlocks. Add no replacement test that restates the removed one.
4. Run the owner's tests and the project's checks.

Done when the report lists production and test lines removed separately, and each suspicious test kept, with the reason.
