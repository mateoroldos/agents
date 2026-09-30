# Landing

Pushing publishes a pull request; do it only when the workflow's gate allows it. Push only the lowest unmerged pull request, so it is based on trunk; `<top-id>` is its last change.

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
gh pr create --head <bookmark> --base <trunk-branch> --title "<subject>" --body-file <description.md>
```

For a pull request the workflow lets merge itself, queue the merge; it runs once the required checks pass:

```sh
gh pr merge <bookmark> --auto --rebase --delete-branch
```

Done when the remote holds exactly the tested stack and the pull request URL is reported.

## 4. After the merge

```sh
jj git fetch
jj log -r 'trunk()..@'
```

jj recognizes the merged changes as rewritten and rebases the rest of the stack onto trunk, so the log shows only unmerged work. If it still shows merged changes, stop and report. The next pull request starts again at step 1.
