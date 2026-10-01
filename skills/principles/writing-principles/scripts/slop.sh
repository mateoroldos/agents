#!/usr/bin/env bash
# Print lines in the given files that match high-precision slop patterns. Exit 1 on any hit.
pattern='\b(currently|previously|no longer|as of (now|today|this)|recently (added|changed)|we (now|fixed|added|changed|updated)|was (added|changed|updated|fixed) to|note that|it(.s| is) (important|worth noting)|in order to|delve|crucial|pivotal|seamless(ly)?|robust|leverag(e|es|ing)|utiliz(e|es|ing)|comprehensive|serves as|not (just|only) .* but|simply|effortless(ly)?|powerful)\b|—|[\x{1F300}-\x{1FAFF}\x{2705}\x{2728}]'
grep -nHiP -- "$pattern" "$@" && exit 1 || exit 0
