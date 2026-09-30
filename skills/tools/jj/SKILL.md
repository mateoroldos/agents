---
name: jj
description: Jujutsu (jj) mechanics. Use before any version-control command in a repository with a `.jj` directory, including starting or describing a change, moving a fix into an earlier change, splitting or reordering changes, inspecting a stack, recovering lost or wrong work, running parallel agents, and pushing.
metadata:
  family: knowledge
---

# jj

Mechanics only: the workflow using this skill decides when a change starts and when work lands. Written against jj 0.45; run `jj help <command>` before using a flag not shown here.

In a repository with `.jj`, write only through jj. `git commit`, `checkout`, `switch`, `reset`, `rebase`, `stash`, and `push` bypass jj and leave its view stale.

The working copy is a change (`@`) that every jj command snapshots. Refer to changes by change ID; commit IDs change on every rewrite.

## Start a change

Match the subject style of `jj log -r '::trunk()' -n 10`.

| `@` is | Command |
| --- | --- |
| empty and undescribed | `jj describe -m "<subject>"` |
| anything else | `jj new -m "<subject>"` |

Never describe, squash, split, or abandon a change you did not create in this task. If `@` holds work you can't account for, start on top of it with `jj new` and report it.

## Inspect

```sh
jj status
jj log -r 'trunk()..@'                                  # the stack
jj show <id>                                            # one change, with its diff
jj log -r 'trunk()..@ & (conflicts() | divergent())'    # must print nothing
```

## Put work where it belongs

| Need | Command |
| --- | --- |
| Send each fixed line to the earlier change that last touched it | `jj absorb`, then check with `jj op show -p` |
| Fold the working copy into one change | `jj squash --into <id>` (add paths to move only those) |
| Split a mixed change by files | `jj split -r <id> -m "<subject of the part with these files>" <paths>` |
| Reorder | `jj rebase -r <id> -A <after>` or `-B <before>` |

Descendants rebase automatically. Resolve a conflict before starting new work: `jj resolve --list`.

## Recover

Every jj command is an operation, so the operation log is the undo history. Nothing jj snapshotted is lost.

```sh
jj op log -n 20          # find the operation before the mistake
jj undo                  # revert only the latest operation
jj op restore <op-id>    # return the whole repository to that operation
jj evolog -r <id>        # earlier versions of one change
jj abandon <id>          # discard a change; first check its descendants with jj log -r '<id>::'
```

Ignored and untracked files are outside the operation log.

## Parallel writers

Each concurrent writer gets its own workspace and its own change; two workspaces never rewrite the same change.

```sh
jj workspace add --name <writer> -r @ <path>
jj workspace forget <writer>    # only after its changes are kept or abandoned
```

## Stop

Stop and report instead of guessing on a conflict, divergence, a conflicted bookmark, or a stack that holds changes you did not expect.

To push, read [`references/landing.md`](references/landing.md).
