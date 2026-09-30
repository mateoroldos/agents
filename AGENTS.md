# agents

Source for my global agent instructions and skills. `agents-sync.fish` symlinks them into Claude Code, Codex, opencode, and Pi, so every edit here is live in every agent session on this machine.

- `AGENTS.global.md`: the global base layer every harness loads. This file only covers working in this repo.
- `skills/<name>/SKILL.md`: flat, one level deep. Each skill belongs to one family; see `README.md`.
- `adapters/<harness>.fish`: where each harness reads the global file and skills. Each harness skills dir holds one link per skill, never a link to `skills/` itself.

```fish
./agents-doctor.fish   # validate instructions, skills, and the machine's links
./agents-sync.fish     # recreate the links after adding a harness or moving a file
```

## Boundaries

- `AGENTS.global.md` affects every project at once. Show the proposed diff and wait for approval before writing it.
- Keep `AGENTS.global.md` harness-neutral: no harness-specific syntax such as `@` imports, and no project or tool facts.
- Before creating or editing a skill, read `skills/writing-great-skills/SKILL.md` and hold the skill to it.
- `effect-ts` and `agent-browser` are unmodified third-party skills. Don't edit them; update them with the skills CLI as described in `README.md`.
- When a skill adapts someone else's work, add or update its row in `CREDITS.md`.

Run `./agents-doctor.fish` after every change.
