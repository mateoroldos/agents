---
name: jj-agent-workflow
description: Jujutsu turn checkpoints. Use before modifying files in a jj repository, when resuming or reviewing agent changes, when the user wants to keep or discard a turn, when concurrent writing agents need isolation, or when preparing changes to land.
metadata:
  family: technique
---

# jj Turn Checkpoints

One mutating agent turn owns one provisional jj change. That boundary makes the turn inspectable and lets the human discard it without disturbing pre-existing work.

The working copy is already a commit and jj snapshots it automatically. Use change IDs for identity; commit IDs change as the working copy evolves.

Read-only discovery and planning do not open a checkpoint. Open the turn immediately before the first repository mutation.

## Open the turn

Before the first edit, inspect the current state:

```sh
jj status
jj log -r '@ | @-' --no-graph
jj log -r '@ & (conflicts() | divergent())' --no-graph
```

Do not normalize, describe, squash, or otherwise rewrite an existing non-empty or described change. If its ownership is unclear or `@` contains conflicts or divergence, stop and report that state.

If `@` is empty, undescribed, and has no bookmark, claim it:

```sh
jj describe -m "agent: <intent>"
```

Otherwise preserve it as the parent and create a child:

```sh
jj new @ -m "agent: <intent>"
```

Record the new change ID. Keep every tracked edit made during this agent turn in that change. A correction in a later turn gets another child change; do not silently amend the earlier turn.

## Close the turn

Inspect the complete change and run the smallest relevant deterministic checks:

```sh
jj status
jj diff --summary
jj diff
jj log -r '@ & (conflicts() | divergent())' --no-graph
```

Account for every edit. If ownership is unclear, stop rather than deleting it. If the turn produced no tracked change, run `jj abandon @`. Otherwise describe the actual outcome and leave a fresh empty working copy:

```sh
jj commit -m "agent: <actual outcome>"
jj log -r @- --no-graph -T 'change_id.short(8) ++ " " ++ description.first_line() ++ "\n"'
```

`jj commit` describes the current change and creates an empty child. The completed turn is `@-`; the new `@` is ready for later human or agent work.

A checkpoint may preserve a failed attempt, but the response must report failing checks and incomplete behavior rather than presenting it as complete.

**Complete when:** the turn has one change ID, its diff contains only turn-owned edits, relevant checks and conflict state are known, and the response reports the change ID with:

```text
inspect: jj show <change-id> · discard: jj abandon <change-id>
```

## Keep, discard, recover

- Keep a turn by leaving its change intact.
- Discard an unlanded turn with `jj abandon <change-id>`. This rebases descendants, so inspect `<change-id>::` before abandoning an older turn.
- Use `jj undo` only for the latest accidental jj operation, not to discard a whole turn.
- Use `jj op log` and `jj --at-op=<operation-id>` to inspect deeper recovery options before changing repository state.
- Report untracked or external side effects; jj cannot discard what it does not track.

## Concurrent writers

Each concurrent writing agent gets its own jj workspace and its own change:

```sh
jj workspace add --name <agent> -r @ <path>
```

One writer owns one workspace and one active change. Never let two workspaces amend the same change. Work from the new workspace directory; forget it only after its changes are preserved or deliberately abandoned.

## Landing

Checkpoint history is provisional. Curate descriptions and commit boundaries, create bookmarks, and push only when the user explicitly requests publication. Then read [`references/landing.md`](references/landing.md).
