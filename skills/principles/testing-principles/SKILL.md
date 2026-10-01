---
name: testing-principles
description: How we judge tests: whether one should exist, at which boundary, and how it is written. Use when choosing how to prove a change, when writing, changing, or reviewing a test, or when asked to audit or prune a test suite.
---

# Testing Principles

A test pays for its upkeep only by catching a regression nothing else catches. The same bar applies to a new test and an existing one.

## Cheapest proof

Prove each change with the cheapest proof that is enough; a new test is the last row, not the default.

| Proof | Enough when |
| --- | --- |
| Types | the compiler rules the failure out |
| An existing test | a test already owns this contract |
| The running app | the change is UI, copy, layout, or wiring best judged by using it |
| Review | config, renames, docs, one-off scripts, prototypes |
| A new test | a behavior or contract with a credible regression that nothing above catches |

- **Why:** every test is code someone maintains and reads.
- **Smell:** a test for a rename, a config value, or what the compiler rules out.

## Pass the gate

A test lands only with all four answers; a missing answer means no test.

1. **Behavior:** what observable behavior or contract does it protect?
2. **Regression:** what credible change to the code would make it fail?
3. **Owner:** why doesn't existing coverage catch that? Each contract has one primary test at the strongest boundary that exercises it; another layer gets a test only for a risk the owner can't reach. Extend a table or fixture instead of adding a near-duplicate.
4. **Seam:** does it need an export, flag, wrapper, or hook that no production caller needs? Then test at the real boundary instead.

Write each test that passes as [`references/writing.md`](references/writing.md) describes.

- **Why:** the regression answer is what the test is for; without it the test is upkeep with no return.
- **Smell:** a test that would break under a refactor that preserves behavior.

## One failing test per bug

A bug's regression test must be seen failing on the code before the fix, for the reported reason. One test at the owner boundary covers the bug; don't replay it at every layer it crosses.

- **Why:** a regression test never seen failing may not test the bug.
- **Smell:** the same bug asserted at three layers.

## No junk

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

## Keep what only it guards

Keep a test that looks like implementation when it is the only guard of a public API, protocol, stored format or migration, security rule, config default, or observable ordering. Slow or static is not a reason to delete a test.

- **Why:** deleting the only guard of a contract makes its regression invisible.
- **Smell:** a kept test fails on untouched code: it may have found a product bug, so reproduce it before changing the test.

To audit or prune an existing suite, read [`references/audit.md`](references/audit.md).
