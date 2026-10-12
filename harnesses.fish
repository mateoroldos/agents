# Where each harness reads the global instructions and skills; sourced by agents-sync.fish and agents-doctor.fish.

# Claude Code, Codex, opencode, Pi.
set instruction_links \
    "$HOME/.claude/CLAUDE.md" \
    "$HOME/.codex/AGENTS.md" \
    "$HOME/.config/opencode/AGENTS.md" \
    "$HOME/.pi/agent/AGENTS.md"

# Claude Code reads only its own skills directory; Codex, opencode, and Pi read ~/.agents/skills.
# opencode 2.0.16 also scans ~/.claude/skills recursively; it has no switch to turn that off.
set skills_dirs "$HOME/.claude/skills" "$HOME/.agents/skills"
