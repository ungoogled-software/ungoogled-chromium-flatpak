#!/usr/bin/env bash

# schema is as follows:
#   {"refs": {"com.github.Eloston.UngoogledChromium": { "x86_64": [1,0] } } }
# where the first number is the installs and the second number is the updates
# NOTE: installs are counted as updates as well, so for new installs you would
#       do installs - updates to get the number of new installs

set -euf -o pipefail
export LC_ALL=en_US.UTF-8  # for printf to use comma as thousands separator

if [[ "$#" -lt 1 ]]; then
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

declare -A app_ids
old_app_id=com.github.Eloston.UngoogledChromium
new_app_id=io.github.ungoogled_software.ungoogled_chromium
declare -i old_sum new_sum

for app_id in "${old_app_id}" "${new_app_id}"; do
    printf "%s: " "${app_id}"
    sum=$(curl --silent --compressed --fail "https://hub.flathub.org/stats/stable/${date:?}.json" | \
          jq --arg app_id "${app_id}" '.refs[$app_id] // [] | map(.[] | select(. != null))' | \
          awk 'BEGIN {sum=0} {sum+=$1} END {print sum}')
    printf "%'d\n" "${sum}"
    app_ids["${app_id}"]=${sum}
done

old_sum=${app_ids[${old_app_id}]}
new_sum=${app_ids[${new_app_id}]}
percentage=$(awk "BEGIN {print ${new_sum} / (${old_sum} + ${new_sum}) * 100}")
printf "Percentage of users that have migrated: %.2f%%\n" "${percentage}"

exit 0
