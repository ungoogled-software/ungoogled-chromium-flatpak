#!/usr/bin/env bash

# schema is as follows:
#   {"refs": {"com.github.Eloston.UngoogledChromium": { "x86_64": [1,0] } } }
# where the first number is the installs and the second number is the updates
# NOTE: installs are counted as updates as well, so for new installs you would
#       do installs - updates to get the number of new installs

set -euf -o pipefail
export LC_ALL=en_US.UTF-8  # for printf to use comma as thousands separator

if [ "$#" -lt 1 ]; then
    echo >&2 "Usage: $0 <date>"
    echo >&2
    echo >&2 "  <date> could be a date string like 'yesterday' or '2 days ago'"
    echo >&2 "  or a date string like '2021-01-01'"
    echo >&2
    exit 1
fi

#date=$(date -u +%Y/%m/%d -d "yesterday")
#date=$(date -u +%Y/%m/%d -d "2 days ago")
date=$(date -u '+%Y/%m/%d' -d "$*")

for app_id in com.github.Eloston.UngoogledChromium io.github.ungoogled_software.ungoogled_chromium; do
    printf "%s: " "$app_id"
    curl --silent --compressed --fail "https://hub.flathub.org/stats/stable/${date:?}.json" | \
        jq --arg app_id "$app_id" '.refs[$app_id] // [] | map(.[] | select(. != null))' | \
        awk 'BEGIN {sum=0} {sum+=$1} END {printf "%'"'"'d\n", sum}'
done

exit 0
