#!/usr/bin/env bash

# Safety options
set -euo pipefail

# Print usage if not enough arguments
if [[ "$#" -ne 1 ]] && [[ "$#" -ne 2 ]]; then
    echo >&2 "Usage: $0 <ugc_version> <fp_revision>"
    exit 1
fi

export LC_ALL=C
ugc_version=${1}
fp_revision=${2-1} # Default to 1 if not provided
final_version="${ugc_version}-${fp_revision}"
current_date=$(date +%Y-%m-%d -u)

git checkout master
git pull
sed -E 's|^(\W+)(<!-- NEW_VERSION_MARKER.*)|\1\2\n\1<release version="'"${final_version}"'" date="'"${current_date}"'"/>|' -i io.github.ungoogled_software.ungoogled_chromium.metainfo.xml
git submodule update --remote src
git -C src checkout "tags/${ugc_version}"
git add io.github.ungoogled_software.ungoogled_chromium.metainfo.xml src
git commit -m "Update Ungoogled Chromium Flatpak to ${final_version}" -s
git tag -m "Ungoogled Chromium Flatpak ${final_version}" "${final_version}"
echo "Run the following commands to push the changes:"
echo "  git push origin master"
echo "  git push origin --tags"
echo "Successfully updated to ${final_version}"
