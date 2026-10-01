#!/usr/bin/env bash
# Fail when a plan passes 80 non-empty lines or its Design section passes 30.
status=0
for plan in "$@"; do
  total=$(grep -c . "$plan")
  design=$(awk '/^## Design: / { on = 1; next } /^## / { on = 0 } on && NF { n++ } END { print n + 0 }' "$plan")
  (( total > 80 )) && { echo "$plan: plan is $total non-empty lines, max 80"; status=1; }
  (( design > 30 )) && { echo "$plan: Design is $design lines, max 30; split the pull request"; status=1; }
done
exit $status
