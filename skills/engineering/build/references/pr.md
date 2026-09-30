# Review packet

The pull request body. It answers what a reviewer needs in the order they need it, so they read the key lines instead of the whole diff. Leave out a section with nothing to say.

```markdown
## Why

<One to three lines: the problem and the behavior now. Link the plan if there is one.>

## Map

In order; ▸ read closely, · skim.

1. `<change subject>`  ▸ `<file>`: `<symbol>`
2. `<change subject>`  · <what to look at instead, such as a screenshot>

## Decisions made without you

- <assumption>: <why>

## Evidence

- <check or verify step>: <result>
- Not verified: <what, and why>

## Review

- Cut: <kinds and counts>
- <reviewer>: <finding>, fixed | answered: <reason>
```

Mark ▸ on types and signatures, stakes lines (migrations, access policy, anything irreversible), and test names with their assertions. For UI, show a screenshot instead of asking for markup to be read.

A stack over about 400 changed lines is a planning failure. Split it into more pull requests before writing the packet.
