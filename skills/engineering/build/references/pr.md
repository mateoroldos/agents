# Pull request description

It tells whoever approves the merge what trunk gains and how to undo it, then where to look, so they read the key lines instead of the whole diff. Leave out a section with nothing to say.

```markdown
<One or two lines: what merging this does to trunk, and why. Link the plan if there is one.>

Live: <users see nothing | behind `<flag>`, off | <the new behavior>> · Undo: <revert | what blocks it, and the way back>
Stack: <n> of <m> · on #<prev> | on trunk · next: <what PR n+1 adds> · ask | show

## Decisions made without you

- <assumption>: <why>

## Map

In order; ▸ read closely, · skim.

1. `<change subject>`  ▸ `<file>`: `<symbol>`
2. `<change subject>`  · <what to look at instead, such as a screenshot>

## Evidence

- <check or verify step>: <result>
- Not verified: <what, and why>

## Review

- <reviewer>: <finding>, fixed | answered: <reason>
```

Copy `Live` and `Undo` from the pull request's row in the plan's Trunk path. Re-read the description before merging; rewrite any line the review made false.

Mark ▸ on types and signatures, stakes lines (migrations, access policy, anything irreversible), and test names with their assertions. For UI, show a screenshot instead of asking for markup to be read.

A pull request over about 400 changed lines is a planning failure. Split it in the plan before writing the description.
