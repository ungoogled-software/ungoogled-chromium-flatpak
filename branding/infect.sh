#!/bin/sh

if [ "$#" -ne 2 ]
then
    echo "Usage: $0 <ugc_fp> <chromium_src>" >&2
    exit 1
fi

ugc_fp=${1}
chromium_src=${2}
branding_path="${ugc_fp}/branding"

if ! [ -f "${branding_path}/.RDStuOZQ7y" ]
then
    echo "Please provide a valid path to the UGC Flatpak repository" >&2
    exit 1
fi

exec cp -rv "${branding_path}/to_copy/." "${chromium_src}/."
