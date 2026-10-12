#!/usr/bin/env fish

set script_dir (dirname (status --current-filename))
set repo (realpath "$script_dir")
source "$repo/harnesses.fish"

if not test -e "$repo/AGENTS.global.md"
    echo "missing AGENTS.global.md at $repo/AGENTS.global.md" >&2
    exit 1
end

# Owned skills live in skills/<name>; the skills CLI installs third-party ones in vendor/skills/<name>.
set skill_files "$repo/skills"/*/SKILL.md "$repo/vendor/skills"/*/SKILL.md

# Links a source into place, refusing to replace anything that is not already a symlink.
function link_into_place --argument-names src dest
    mkdir -p (dirname "$dest")

    if test -e "$dest"; and not test -L "$dest"
        echo "refusing to replace non-symlink: $dest" >&2
        return 1
    end

    ln -sfn "$src" "$dest"
    echo "linked $dest -> $src"
end

for dest in $instruction_links
    link_into_place "$repo/AGENTS.global.md" "$dest"; or exit 1
end

# Each skills dir is a real directory owned by its harness, holding one link per repo skill,
# so nothing a harness writes there reaches the repo.
for dir in $skills_dirs
    if test -L "$dir"
        rm "$dir"
        echo "replaced directory link $dir"
    end
    mkdir -p "$dir"

    for skill_file in $skill_files
        set skill (dirname "$skill_file")
        link_into_place $skill "$dir/"(basename "$skill"); or exit 1
    end

    for entry in "$dir"/*
        set target (readlink "$entry")
        if test -L "$entry"; and string match -q -r -- "^$repo/(skills|vendor/skills)/" "$target"; and not test -e "$entry"
            rm "$entry"
            echo "removed stale link $entry"
        end
    end
end
