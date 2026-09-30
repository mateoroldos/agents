# agents

Source for my global agent instructions and skills. `agents-sync.fish` symlinks them into Claude Code, Codex, opencode, and Pi, so every edit here is live in every agent session on this machine.

- `AGENTS.global.md`: the global base layer every harness loads. This file only covers working in this repo.
- `skills/<category>/<name>/SKILL.md`: owned skills. Category, family, and invocation are defined in `README.md`.
- `vendor/skills/<name>/SKILL.md`: third-party skills owned by the skills CLI.
- `adapters/<harness>.fish`: where each harness reads the global file and skills. Each harness skills dir holds one link per skill, never a link to `skills/` itself.

```fish
./agents-doctor.fish   # validate instructions, skills, and the machine's links
./agents-sync.fish     # recreate the links after adding a harness or moving a file
```

## Boundaries

- `AGENTS.global.md` affects every project at once. Show the proposed diff and wait for approval before writing it.
- Keep `AGENTS.global.md` harness-neutral: no harness-specific syntax such as `@` imports, and no project or tool facts.
- Before creating or editing a skill, use the `write-skill` skill.
- Refer to other skills by name, never by relative path: categories nest in the repo but harnesses see a flat list.
- Never edit `vendor/`. Install and update it with the skills CLI from inside `vendor/`, as described in `README.md`.
- When a skill adapts someone else's work, add or update its row in `CREDITS.md`.

Run `./agents-doctor.fish` after every change.
