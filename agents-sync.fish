#!/usr/bin/env fish

set script_dir (dirname (status --current-filename))
set repo (realpath "$script_dir")
set adapters "$repo/adapters"/*.fish

if not test -e "$repo/AGENTS.md"
    echo "missing AGENTS.md at $repo/AGENTS.md" >&2
    exit 1
end

if not test -d "$repo/skills"
    echo "missing skills directory at $repo/skills" >&2
    exit 1
end

for adapter in $adapters
    set -e adapter_name
    set -e adapter_links
    set -e adapter_generated_files

    source "$adapter"

    if not set -q adapter_name
        echo "adapter missing adapter_name: $adapter" >&2
        exit 1
    end

    for link in $adapter_links
        set parts (string split -m 1 : "$link")
        set src $parts[1]
        set dest $parts[2]

        if not test -e "$src"
            echo "$adapter_name: source does not exist: $src" >&2
            exit 1
        end

        mkdir -p (dirname "$dest")

        if test -e "$dest"; or test -L "$dest"
            if not test -L "$dest"
                echo "$adapter_name: refusing to replace non-symlink: $dest" >&2
                exit 1
            end
        end

        ln -sfn "$src" "$dest"
        echo "$adapter_name: linked $dest -> $src"
    end
end
