---
name: github
description: GitHub mechanics with the gh CLI: issues, parent issues and sub-issues, blocked by, labels, linking pull requests to issues, merging, and roadmap boards. Use before any gh command, and when filing an issue, opening, linking, or merging a pull request, marking what needs the user, finding the next issue to work on, or updating a roadmap board.
---

# GitHub

Applies the `delivery-principles` skill with GitHub. Run `gh <command> --help` before using a flag not shown here.

An epic is a parent issue; its issues are sub-issues.

GitHub's fields hold an issue's relations: parent, blocked by, and linked pull requests. Never restate them in text.

## Issues

| Need | Command |
| --- | --- |
| File a sub-issue | `gh issue create --parent <parent> --title "<outcome>" --body-file <body.md>` |
| Attach an existing issue | `gh issue edit <parent> --add-sub-issue <n>` |
| Block one issue on another | `gh issue edit <n> --add-blocked-by <m>` · `--remove-blocked-by <m>` |
| Find the next issue | `gh issue list --search "is:open -is:blocked"` |

Closing a parent's last sub-issue does not close the parent.

## Needs you

The `needs-you` label marks every issue and pull request waiting on the user, so one query answers "what needs me?".

| Need | Command |
| --- | --- |
| Create it, once per repository | `gh label create needs-you --color 8250DF --description "Waiting on the user"` |
| Mark or clear | `gh issue edit <n> --add-label needs-you` · `gh pr edit <n> --remove-label needs-you` |
| Everything waiting on the user | `gh search issues --include-prs --owner <owner> --label needs-you --state open` |

Clear it as soon as the user has answered.

## Pull requests

| Description says | Effect |
| --- | --- |
| `Closes #<n>` | Links the pull request in the issue's Development panel, and closes the issue on merge |
| `Part of #<n>` | Only a mention in the issue's timeline |

```sh
gh pr create --head <branch> --base <trunk-branch> --title "<subject>" --body-file <description.md>
gh pr merge <branch> --<squash|merge|rebase> --delete-branch   # the method the repository uses
```

When the repository squash merges, this makes the pull request's title and description the trunk commit:

```sh
gh api -X PATCH repos/<owner>/<repo> -f squash_merge_commit_title=PR_TITLE -f squash_merge_commit_message=PR_BODY
```

## Roadmap board

A Projects board is the roadmap: parent issues and issues without a parent, never sub-issues or pull requests. The project's AGENTS.md names its board.

| When | Do |
| --- | --- |
| A parent issue is filed | `gh project item-add <number> --owner <owner> --url <issue URL>` |
| Its first sub-issue starts | Set Status to In Progress with `gh project item-edit`; find the ids with `gh project field-list <number> --owner <owner> --format json` and `gh project item-list` |
| It closes | Nothing: the built-in "Item closed" workflow sets Done |

Built-in workflows change only in the board's UI: keep "Auto-add sub-issues to project" off, so the board shows only the big picture.
