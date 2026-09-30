set adapter_name opencode

set adapter_links \
    "$repo/AGENTS.global.md:$HOME/.config/opencode/AGENTS.md"

# opencode 2.0.16 also scans ~/.claude/skills recursively; it has no switch to turn that off.
set adapter_skills_dir "$HOME/.agents/skills"
