#!/usr/bin/env fish

set script_dir (dirname (status --current-filename))
set repo (realpath "$script_dir")
set failed 0
set names

function fail
    echo "error: $argv" >&2
    set -g failed 1
end

if not test -e "$repo/AGENTS.md"
    fail "missing AGENTS.md"
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
