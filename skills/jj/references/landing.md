# Landing

Pushing publishes a pull request; push only when the user asks to open or update one. `<top-id>` is the pull request's last change.

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
gh pr create --head <bookmark> --title "<subject>" --body-file <description.md>
```

Done when the remote holds exactly the tested stack and the pull request URL is reported.

## 4. After the merge

Rebase the rest of the stack onto trunk; changes the merge already holds become empty and are dropped, whichever merge method the repository uses:

```sh
jj git fetch
jj rebase -b @ -o 'trunk()' --skip-emptied
jj log -r 'trunk()..@'      # must show only unmerged work
```

If it still shows a merged change, stop and report. The next pull request starts again at step 1.
