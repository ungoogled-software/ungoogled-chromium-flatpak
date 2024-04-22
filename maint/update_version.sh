#!/usr/bin/env bash

if [[ "$#" -ne 1 ]]; then
    echo >&2 "Usage: $0 <new_version>"
    exit 1
fi

export LC_ALL=C
new_version=${1}
current_date=$(date +%Y-%m-%d -u)

git checkout master
git pull
sed -E 's|^(\W+)(<!-- NEW_VERSION_MARKER.*)|\1\2\n\1<release version="'"${new_version}"'" date="'"${current_date}"'"/>|' -i io.github.ungoogled_software.ungoogled_chromium.metainfo.xml
git submodule update --remote src
git -C src checkout "tags/${new_version}"
git add io.github.ungoogled_software.ungoogled_chromium.metainfo.xml src
git commit -m "Update Ungoogled Chromium to ${new_version}" -s
git tag -m "Ungoogled Chromium ${new_version}" "${new_version}"
echo "Run the following commands to push the changes:"
echo "  git push origin master"
echo "  git push origin --tags"
echo "Successfully updated to ${new_version}"
