# Agents

Shared agent instructions and skills for Claude Code, opencode, and Pi.

## Usage

Run the sync script to link `AGENTS.md` and `skills/` into each supported tool:

```fish
./agents-sync.fish
```

Check that the repo is valid with:

```fish
./agents-doctor.fish
```

## Skills

Flat by necessity: Claude Code scans `~/.claude/skills/<name>/SKILL.md` exactly one level
deep, so categories as subdirectories would be invisible to it.

Each skill belongs to one family, and the family is what makes it wrong:

| Family | Wrong when | Shape |
| --- | --- | --- |
| Standard | you change your mind | flat reference, no steps |
| Technique | your process changes | ordered steps + completion criteria |
| Knowledge | the library ships | branch-chooser reference, version-pinned |

A skill mixing two families rots unevenly — keep them apart.

| Skill | Family | |
| --- | --- | --- |
| `type-driven-development` | Technique | Shape TypeScript from domain types through modules and proof |
| `design-engineering` | Standard | UI polish, component design, animation decisions |
| `effect-ts` | Technique | Official Effect repository setup |
| `effect-patterns` | Knowledge | Version-aware Effect application architecture and patterns |
| `show-me` | Standard | Explain flows, structure, and changes with compact visual artifacts |
| `repo-librarian` | Knowledge | Local reference library of remote git repositories |
| `agent-browser` | Knowledge | Browser automation via the `agent-browser` CLI (vendored stub) |
| `jj-agent-workflow` | Technique | Isolate each mutating agent turn as a reviewable, discardable jj change |
| `shape-feature` | Technique | Shape uncertain features before implementation (user-invoked) |
| `writing-great-skills` | Standard | The bar every skill here is held to (user-invoked) |
| `plannotator-*` | Technique | Annotation and review UI wrappers (user-invoked) |

Attribution for skills adapted from other developers: [CREDITS.md](CREDITS.md).

Unmodified third-party skills are installed and updated with the [skills CLI](https://github.com/vercel-labs/skills),
which records their source in `skills-lock.json`. `-a openclaw` is used only because its project
skills directory is `skills/`:

```fish
npx skills add <owner>/<repo> -s <skill> -a openclaw --copy   # install
npx skills update -p                                          # update
```
