#!/usr/bin/env fish

set script_dir (dirname (status --current-filename))
set repo (realpath "$script_dir")
set failed 0
set names

function fail
    echo "error: $argv" >&2
    set -g failed 1
end

for file in AGENTS.global.md AGENTS.md
    if not test -e "$repo/$file"
        fail "missing $file"
    end
end

# Harnesses walk up parent directories, so a file in $HOME loads on top of each global file.
for stray in "$HOME/AGENTS.md" "$HOME/CLAUDE.md"
    if test -e "$stray"; or test -L "$stray"
        fail "$stray duplicates the global instructions in every project under \$HOME; remove it"
    end
end

set skills_dirs

for adapter in "$repo/adapters"/*.fish
    set -e adapter_name
    set -e adapter_links
    set -e adapter_skills_dir
    source "$adapter"

    for link in $adapter_links
        set parts (string split -m 1 : "$link")
        set target (readlink "$parts[2]")
        if test "$target" != "$parts[1]"
            fail "$adapter_name: $parts[2] is not linked to $parts[1]; run agents-sync.fish"
        end
    end

    if set -q adapter_skills_dir; and not contains -- "$adapter_skills_dir" $skills_dirs
        set skills_dirs $skills_dirs "$adapter_skills_dir"
    end
end

# Each harness skills dir must be a real directory holding exactly one link per repo skill.
for dir in $skills_dirs
    if test -L "$dir"; or not test -d "$dir"
        fail "$dir must be a real directory; run agents-sync.fish"
        continue
    end

    for skill_file in "$repo/skills"/*/SKILL.md
        set skill (dirname "$skill_file")
        set target (readlink "$dir/"(basename "$skill"))
        if test "$target" != "$skill"
            fail "$dir/"(basename "$skill")" is not linked to $skill; run agents-sync.fish"
        end
    end

    for entry in "$dir"/*
        if not test -L "$entry"
            fail "$entry is not a link to this repo; move it into skills/ or remove it"
        else if not test -e "$entry"
            fail "$entry is a broken link; run agents-sync.fish"
        end
    end
end

if not test -d "$repo/skills"
    fail "missing skills directory"
end

for skill in "$repo/skills"/*
    if not test -d "$skill"
        continue
    end

    set dir_name (basename "$skill")
    set file "$skill/SKILL.md"

    if not test -e "$file"
        fail "$dir_name: missing SKILL.md"
        continue
    end

    set lines (string split \n -- (string collect < "$file"))

    if test "$lines[1]" != "---"
        fail "$dir_name: SKILL.md must start with YAML frontmatter"
        continue
    end

    set end_line 0
    for idx in (seq 2 (count $lines))
        if test "$lines[$idx]" = "---"
            set end_line $idx
            break
        end
    end

    if test "$end_line" -eq 0
        fail "$dir_name: missing closing frontmatter marker"
        continue
    end

    set name ""
    set description ""

    for idx in (seq 2 (math $end_line - 1))
        set line "$lines[$idx]"

        if string match -qr '^name:' -- "$line"
            set name (string trim (string replace -r '^name:[ ]*' '' -- "$line"))
            set name (string trim --chars='"\'' -- "$name")
        end

        if string match -qr '^description:' -- "$line"
            set description (string trim (string replace -r '^description:[ ]*' '' -- "$line"))
            set description (string trim --chars='"\'' -- "$description")
        end
    end

    if test -z "$name"
        fail "$dir_name: missing name"
        continue
    end

    if test -z "$description"
        fail "$dir_name: missing description"
    end

    if not string match -qr '^[a-z0-9]+(-[a-z0-9]+)*$' -- "$name"
        fail "$dir_name: invalid name: $name"
    end

    if test "$name" != "$dir_name"
        fail "$dir_name: name must match directory name: $name"
    end

    if test (string length -- "$description") -gt 1024
        fail "$dir_name: description exceeds 1024 characters"
    end

    if contains -- "$name" $names
        fail "$dir_name: duplicate skill name: $name"
    else
        set names $names "$name"
    end
end

if test "$failed" -eq 1
    exit 1
end

echo "ok: AGENTS.md and "(count $names)" skills look valid"
