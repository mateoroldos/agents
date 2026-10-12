# Agents

Shared agent instructions and skills for Claude Code, Codex, opencode, and Pi.

## Usage

Run the sync script to link `AGENTS.global.md` and each skill into every supported tool. `AGENTS.md` holds instructions for working in this repo.

| Harness | Instructions | Skills |
| --- | --- | --- |
| Claude Code | `~/.claude/CLAUDE.md` | `~/.claude/skills/<name>` |
| Codex, opencode, Pi | their own global `AGENTS.md` | `~/.agents/skills/<name>` |

Skills dirs hold one link per skill, so anything a harness writes there stays out of this repo.

```fish
./agents-sync.fish
```

Check that the repo is valid with:

```fish
./agents-doctor.fish
```

## Skills

Skills hold knowledge the model lacks: libraries, our principles for types, tests, design, and writing, and jj mechanics. How work ships lives in the Shipping section of `AGENTS.global.md`, not in a skill.

```text
skills/<name>/SKILL.md           owned: written and edited here
vendor/skills/<name>/SKILL.md    third-party: installed by the skills CLI, never edited
```

`agents-sync.fish` links every skill into each harness skills dir by name, so names must be unique. Skills refer to each other by name, never by relative path.

`ls skills vendor/skills` is the catalog. `agents-doctor.fish` fails on invalid frontmatter, a duplicate name, a vendored skill without a lock entry, a name that points at a missing skill, or a missing link.

Attribution for skills adapted from other developers: [CREDITS.md](CREDITS.md).

### Third-party skills

| Mode | When | Where |
| --- | --- | --- |
| Adopt | use it unchanged | `vendor/`, installed and updated by the skills CLI |
| Adapt | you want to change it | `skills/<name>`, plus a row in `CREDITS.md` |
| Try | one-off use | `npx skills use <owner>/<repo>@<skill>`, nothing installed |

`vendor/` is the [skills CLI](https://github.com/vercel-labs/skills)'s project: run it from there so it writes
`vendor/skills/` and `vendor/skills-lock.json`. `-a openclaw` is used only because its project skills directory
is `skills/`. Read the diff after every update: skills run with full agent permissions.

```fish
cd vendor
npx skills add <owner>/<repo> -s <skill> -a openclaw --copy   # install
npx skills update -p                                          # update
cd .. && ./agents-sync.fish
```
