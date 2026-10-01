---
name: repo-librarian
description: Cache, search, and compare remote git repositories as reference code. Use when the user names a GitHub, GitLab, or Bitbucket repository, or wants examples or patterns from real projects.
---

# Repo Librarian

Finds the precedent in reference repositories for the `plan` skill. A local library of remote repositories: partial clones at stable paths, refreshed by fast-forward only, with reusable notes.

```text
~/.cache/checkouts/<host>/<org>/<repo>                 checkouts
~/.cache/repo-librarian/index.tsv                      index
~/.cache/repo-librarian/notes/<host>/<org>/<repo>.md   notes
```

## Commands

Run each as `bash ~/agents/skills/patterns/repo-librarian/scripts/<script>`. A repository is `owner/repo` (GitHub), `host/owner/repo`, or an HTTPS or SSH URL.

| Need | Script |
| --- | --- |
| Clone or refresh, and print the path | `checkout.sh <repo> --path-only` |
| List cached repositories | `list.sh` |
| Search one, or all | `search.sh <repo> "<pattern>"` · `search-all.sh "<pattern>"` |
| Write or update its note | `analyze.sh <repo>` |
| Tag it | `tags.sh add <repo> <tags…>` · `tags.sh list <repo>` |

## Use

1. Resolve every named repository with `checkout.sh --path-only` before reading it.
2. Start from the README, manifests, config, examples, and tests, then search with `rg` and focused reads.
3. To compare repositories, read the equivalent files in each before concluding.
4. Cite exact paths. Another project's code is precedent, not truth: it shows one way, not that it works here.
5. Save what you will need again in its note.

## Safety

- Never edit inside `~/.cache/checkouts`; copy or use a separate worktree.
- Never reset or discard local changes there.
- Preserve licenses and attribution for anything adapted.
