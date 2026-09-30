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

```text
skills/<category>/<name>/SKILL.md   owned: written and edited here
vendor/skills/<name>/SKILL.md       third-party: installed by the skills CLI, never edited
```

Harnesses see one flat list: `agents-sync.fish` links every skill into each harness skills dir by name,
so names must be unique across categories. Skills refer to each other by name, never by relative path.

Every skill answers three questions:

| Question | Recorded as | Options |
| --- | --- | --- |
| What is it about? | its category directory | `product` · `design` · `engineering` · `stack` · `tools` · `meta` |
| How is it written? | `metadata.family` | `standard` · `technique` · `knowledge` |
| Who invokes it? | `disable-model-invocation` | model (costs context every turn) · user (costs memory) |

The family is what makes a skill wrong:

| Family | Wrong when | Shape |
| --- | --- | --- |
| Standard | you change your mind | flat reference, no steps |
| Technique | your process changes | ordered steps + completion criteria |
| Knowledge | the library ships | branch-chooser reference, version-pinned |

A skill mixing two families rots unevenly — keep them apart.

| Category | Skill | Family | |
| --- | --- | --- | --- |
| product | `shape-feature` | Technique | Shape uncertain features before implementation (user-invoked) |
| design | `design-engineering` | Standard | UI polish, component design, animation decisions |
| design | `show-me` | Standard | Explain flows, structure, and changes with compact visual artifacts |
| engineering | `type-driven-development` | Technique | Shape TypeScript from domain types through modules and proof |
| stack | `effect-patterns` | Knowledge | Version-aware Effect application architecture and patterns |
| tools | `jj-agent-workflow` | Technique | Isolate each mutating agent turn as a reviewable, discardable jj change |
| tools | `repo-librarian` | Knowledge | Local reference library of remote git repositories |
| tools | `plannotator-annotate` | Technique | Annotate a file, URL, or folder in Plannotator (user-invoked) |
| tools | `plannotator-last` | Technique | Annotate the last assistant message in Plannotator (user-invoked) |
| tools | `plannotator-review` | Technique | Review the worktree or a PR in Plannotator (user-invoked) |
| meta | `writing-great-skills` | Standard | The bar every skill here is held to (user-invoked) |
| vendor | `effect-ts` | — | Official Effect repository setup |
| vendor | `agent-browser` | — | Browser automation via the `agent-browser` CLI |

`agents-doctor.fish` fails when a skill sits outside a known category, lacks a family, is missing from
this table, or is vendored without a lock entry.

Attribution for skills adapted from other developers: [CREDITS.md](CREDITS.md).

### Third-party skills

| Mode | When | Where |
| --- | --- | --- |
| Adopt | use it unchanged | `vendor/`, installed and updated by the skills CLI |
| Adapt | you want to change it | an owned category, plus a row in `CREDITS.md` |
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
