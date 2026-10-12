#!/usr/bin/env fish

set script_dir (dirname (status --current-filename))
set repo (realpath "$script_dir")
set failed 0
set -g names
source "$repo/harnesses.fish"

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

set owned_skills
for skill in "$repo/skills"/*
    test -d "$skill"; and set owned_skills $owned_skills "$skill"
end
set vendor_skills
for skill in "$repo/vendor/skills"/*
    test -d "$skill"; and set vendor_skills $vendor_skills "$skill"
end

function check_skill --argument-names skill kind
    set dir_name (basename "$skill")
    set file "$skill/SKILL.md"

    if not test -e "$file"
        fail "$dir_name: missing SKILL.md"
        return
    end

    set lines (string split \n -- (string collect < "$file"))

    if test "$lines[1]" != "---"
        fail "$dir_name: SKILL.md must start with YAML frontmatter"
        return
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
        return
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
        return
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
        set -g names $names "$name"
    end
    if test "$kind" = vendor; and not string match -q -- "*\"$name\":*" (string collect < "$repo/vendor/skills-lock.json")
        fail "$dir_name: vendored skill missing from vendor/skills-lock.json; install it with the skills CLI from vendor/"
    end
end

for skill in $owned_skills
    check_skill $skill owned
end
for skill in $vendor_skills
    check_skill $skill vendor
end

# Skills name each other as "`<name>` skill"; a rename or removal must not leave a dangling name.
for file in "$repo"/AGENTS.md "$repo"/README.md (find "$repo/skills" -name '*.md')
    for name in (string match -r -a -g '`([a-z0-9-]+)` skill' < "$file")
        if not contains -- "$name" $names
            fail (string replace "$repo/" '' "$file")": names the missing skill $name"
        end
    end
end

for dest in $instruction_links
    set target (readlink "$dest")
    if test "$target" != "$repo/AGENTS.global.md"
        fail "$dest is not linked to $repo/AGENTS.global.md; run agents-sync.fish"
    end
end

# Each harness skills dir must be a real directory holding exactly one link per repo skill.
for dir in $skills_dirs
    if test -L "$dir"; or not test -d "$dir"
        fail "$dir must be a real directory; run agents-sync.fish"
        continue
    end

    for skill in $owned_skills $vendor_skills
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

if test "$failed" -eq 1
    exit 1
end

echo "ok: "(count $owned_skills)" owned and "(count $vendor_skills)" vendored skills look valid"
