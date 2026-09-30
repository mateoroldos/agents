#!/usr/bin/env fish

set script_dir (dirname (status --current-filename))
set repo (realpath "$script_dir")
set adapters "$repo/adapters"/*.fish

if not test -e "$repo/AGENTS.global.md"
    echo "missing AGENTS.global.md at $repo/AGENTS.global.md" >&2
    exit 1
end

if not test -d "$repo/skills"
    echo "missing skills directory at $repo/skills" >&2
    exit 1
end

# Owned skills live in skills/<category>/<name>; the skills CLI installs third-party ones in vendor/skills/<name>.
set skill_files "$repo/skills"/*/*/SKILL.md "$repo/vendor/skills"/*/SKILL.md

# Links a source into place, refusing to replace anything that is not already a symlink.
function link_into_place --argument-names owner src dest
    mkdir -p (dirname "$dest")

    if test -e "$dest"; and not test -L "$dest"
        echo "$owner: refusing to replace non-symlink: $dest" >&2
        return 1
    end

    ln -sfn "$src" "$dest"
    echo "$owner: linked $dest -> $src"
end

set skills_dirs

for adapter in $adapters
    set -e adapter_name
    set -e adapter_links
    set -e adapter_skills_dir

    source "$adapter"

    if not set -q adapter_name
        echo "adapter missing adapter_name: $adapter" >&2
        exit 1
    end

    for link in $adapter_links
        set parts (string split -m 1 : "$link")
        if not test -e "$parts[1]"
            echo "$adapter_name: source does not exist: $parts[1]" >&2
            exit 1
        end
        link_into_place $adapter_name $parts[1] $parts[2]; or exit 1
    end

    if set -q adapter_skills_dir; and not contains -- "$adapter_skills_dir" $skills_dirs
        set skills_dirs $skills_dirs "$adapter_skills_dir"
    end
end

# Each skills dir is a real directory owned by its harness, holding one link per repo skill,
# so nothing a harness writes there reaches the repo.
for dir in $skills_dirs
    if test -L "$dir"
        rm "$dir"
        echo "skills: replaced directory link $dir"
    end
    mkdir -p "$dir"

    for skill_file in $skill_files
        set skill (dirname "$skill_file")
        link_into_place skills $skill "$dir/"(basename "$skill"); or exit 1
    end

    for entry in "$dir"/*
        set target (readlink "$entry")
        if test -L "$entry"; and string match -q -r -- "^$repo/(skills|vendor/skills)/" "$target"; and not test -e "$entry"
            rm "$entry"
            echo "skills: removed stale link $entry"
        end
    end
end
