# Landing

Pushing publishes the stack; do it only when the workflow's gate allows it.

## 1. Prove the stack

Fetch, then check that the outgoing changes are exactly the intended ones:

```sh
jj git fetch
jj log -r 'trunk()..<top-id>'
jj log -r 'trunk()..<top-id> & (conflicts() | divergent() | description(exact:""))'   # must print nothing
jj diff --from 'trunk()' --to <top-id> --stat
```

If trunk moved, rebase only the stack and check again:

```sh
jj rebase -b <top-id> -o 'trunk()'
```

Run the project's checks on this exact stack. Checks run on another tree prove nothing about it.

Done when the outgoing log holds only intended, described, conflict-free changes, and the checks passed on them.

## 2. Push one bookmark

```sh
jj git push --named <bookmark>=<top-id> --dry-run
jj git push --named <bookmark>=<top-id>
```

For a bookmark that already exists, move it with `jj bookmark set <bookmark> -r <top-id>`, then `jj git push -b <bookmark>`.

A rejected push, a conflicted bookmark, or an outgoing set that changed after the dry run stops the landing until you have inspected it.

## 3. Open the pull request

```sh
gh pr create --head <bookmark> --base <trunk-branch> --title "<subject>" --body-file <packet.md>
```

Done when the remote holds exactly the tested stack and the pull request URL is reported.
