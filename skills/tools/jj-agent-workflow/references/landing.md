# Curate and Publish

Publication trades turn-level discardability for durable review history. Cross that boundary only on explicit user request.

Before using version-sensitive commands, check the installed `jj` version and matching `jj help`. Treat GitHub stacked pull requests as optional, public-preview integration rather than part of the jj workflow.

## Select and curate

Name the exact turn change IDs to publish. Inspect each with `jj show <id>`; do not infer the set from a broad anonymous branch when unrelated work may share its ancestry.

Keep coherent changes, squash corrections, and split mixed changes. Replace every provisional `agent:` description in the publication set with a conventional description that states the resulting behavior. Do not rewrite changes outside the named set.

If the selected changes need rebasing, preview the exact set, then rebase only those revisions onto remote trunk:

```sh
jj git fetch --remote <remote>
jj log -r '<id-1> | <id-2>'
jj rebase -r '<id-1> | <id-2>' -o 'trunk()'
```

Use the repository's actual remote name. Stop on unexpected topology, remote movement, divergence, or conflicts rather than broadening the revset.

## Prove the publication set

Set a bookmark on the intended top change, then inspect exactly what it would publish:

```sh
jj bookmark set <bookmark> -r <top-id>
jj log -r '::<bookmark> & ~::trunk()'
jj log -r '(::<bookmark> & ~::trunk()) & conflicts()' --no-graph
jj log -r '(::<bookmark> & ~::trunk()) & divergent()' --no-graph
jj bookmark list --conflicted <bookmark>
jj diff --from 'trunk()' --to <bookmark>
```

The outgoing log must contain exactly the intended changes, with no provisional descriptions, conflicts, divergence, or unrelated files. Run the relevant validation from a workspace based on `<bookmark>`; checks from a different tree are not publication proof.

Fetch once more immediately before the push, inspect the dry run, and push only the named bookmark:

```sh
jj git fetch --remote <remote>
jj git push --remote <remote> --bookmark <bookmark> --dry-run
jj git push --remote <remote> --bookmark <bookmark>
```

Any rejected lease, conflicted bookmark, unexpected force update, or changed outgoing set stops publication pending inspection.

For one pull request, use the repository's normal GitHub flow. For an explicitly requested stacked PR, consult the installed `gh stack link --help` and current official documentation; `gh stack link` is the GitHub command intended for branches managed by external tools such as Jujutsu. Do not use Git-driven stack mutation commands to reshape jj history.

**Complete when:** the named bookmark resolves to the intended tested changes, the remote accepted exactly that bookmark, and the resulting pull request target and status are reported.
