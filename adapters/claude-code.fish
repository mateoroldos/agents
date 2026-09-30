set adapter_name claude-code

set adapter_links \
    "$repo/AGENTS.global.md:$HOME/.claude/CLAUDE.md"

# Claude Code reads only its own skills directory.
set adapter_skills_dir "$HOME/.claude/skills"
