# Pull request

In about 25 lines, the description says why, shows what changed, and says where to look and how it was proven. Link the plan; never restate it. Delete an empty section.

```markdown
<Why: what trunk gains, and for whom, in one line.>

Part of #<issue> | Closes #<issue> · [Plan](<full URL>), PR <n>

## Overview

<The shape of the change, shown, not described: the main call stack as a diff from trunk's, a tree of the files that changed (+ new, ~ changed, - removed) when the change is structural, or before and after screenshots for UI.>

## Assumed

- <what you chose without asking>: <why>

## Read closely

- `<file>`: `<symbol>`: <why it needs your eyes>

## Proof

| Protects | Proof (level) | Fails if |
| --- | --- | --- |
| <behavior> | test `<name>` (<level>) \| types \| existing test \| app \| review | <the regression it catches, or —> |

Ran: <commands and results>

⚠️ Not verified: <what, and why>
```

- The title matches trunk's commit subjects.
- Overview shows only the main path, in at most about 12 lines, with real names; the plan's Design has the detail.
- `Closes` goes only on the plan's last pull request.
- Read closely lists only signatures, security-sensitive lines, and assertions worth checking; for UI, a screenshot.
