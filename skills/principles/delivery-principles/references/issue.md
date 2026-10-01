# Issue

An issue says what people can do once it closes: a feature, a bug, or a chore. The tracker's own fields hold its relations (epic, blocked by, linked pull requests); never restate them in text.

```markdown
<Outcome: who can do what, in one line.>

Budget: ~<n> pull requests

Out of scope: <what this leaves out, with the issue that owns it>

Plan: <full URL, once the plan is on trunk>

> [!IMPORTANT]
> **⚠️ Needs you**              <!-- delete when empty -->
>
> - <question>: <your recommendation>

## Decided                      <!-- product decisions the user approved -->

- <one decision per line>
```

- An issue that isn't next is only its outcome and Out of scope line.
- Work over its budget splits into issues of an epic, each blocked by the one before. The epic is one line: what people can do once all of them close.
- A bug's diagnosis goes in its issue.
