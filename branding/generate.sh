#!/bin/sh

# Note:
# - we ignore product_logo_22_mono.png because it seems to only be used for Windows
#   tray icons, and I don't want to bother with that right now.
# - we ignore product_logo_32.xpm because it seems like it's unused
# - we ignore product_logo_name_22{,_white}.png because it's only used for chrome://about
#   and I don't want to bother with that right now. There's no SVG for it anyway.

# safety options
set -eu

# check if we're in the right directory
if ! [ -f .RDStuOZQ7y ]
then
    echo "Please run this script from <root>/branding/chrome/app/theme/chromium" >&2
    exit 1
fi

# set up variables
base_path=$(pwd)
svg_path="${base_path}/logo.svg"
chrome_path="${base_path}/to_copy"
icons_normal="${chrome_path}/chrome/app/theme/chromium/"
icons_normal_linux="${chrome_path}/chrome/app/theme/chromium/linux/"
icons_default100="${chrome_path}/chrome/app/theme/default_100_percent/chromium/"
icons_default100_linux="${chrome_path}/chrome/app/theme/default_100_percent/chromium/linux/"
icons_default200="${chrome_path}/chrome/app/theme/default_200_percent/chromium/"

rm -rf "${chrome_path}"

mkdir -p "${icons_normal}"
cd "${icons_normal}"
cat >BRANDING <<EOF
COMPANY_FULLNAME=The Chromium and Ungoogled Chromium Authors
COMPANY_SHORTNAME=The Chromium and Ungoogled Chromium Authors
PRODUCT_FULLNAME=Ungoogled Chromium
PRODUCT_SHORTNAME=Ungoogled Chromium
PRODUCT_INSTALLER_FULLNAME=Ungoogled Chromium Installer
PRODUCT_INSTALLER_SHORTNAME=Ungoogled Chromium Installer
COPYRIGHT=Copyright @LASTCHANGE_YEAR@ The Chromium and Ungoogled Chromium Authors. All rights reserved.
MAC_BUNDLE_ID=io.github.ungoogled_software.ungoogled_chromium
MAC_CREATOR_CODE=Cr24
MAC_TEAM_ID=
EOF
svgo -q "${svg_path}" -o product_logo.svg
for size in 24 48 64 128 256
do
    rsvg-convert -w "${size}" -h "${size}" -o "product_logo_${size}.png" "${svg_path}"
done

mkdir -p "${icons_normal_linux}"
cd "${icons_normal_linux}"
for size in 24 48 64 128 256
do
    rsvg-convert -w "${size}" -h "${size}" -o "product_logo_${size}.png" "${svg_path}"
    # Chromium uses 256-color indexed color PNGs for Linux icons
    # but if we don't need to do this, then I rather not bother
    # it makes the icon look really bad due to the use of gradients
    # (even with dithering the edges look really bad).
    #magick product_logo_$size.png -dither FloydSteinberg -colors 256 -background none PNG8:product_logo_$size.png
done

mkdir -p "${icons_default100}"
cd "${icons_default100}"
for size in 16 32
do
    rsvg-convert -w "${size}" -h "${size}" -o "product_logo_${size}.png" "${svg_path}"
done

mkdir -p "${icons_default100_linux}"
cd "${icons_default100_linux}"
for size in 16 32
do
    rsvg-convert -w "${size}" -h "${size}" -o "product_logo_${size}.png" "${svg_path}"
    # Chromium uses 256-color indexed color PNGs for Linux icons
    # but if we don't need to do this, then I rather not bother
    # it makes the icon look really bad due to the use of gradients
    # (even with dithering the edges look really bad).
    #magick product_logo_$size.png -dither FloydSteinberg -colors 256 -background none PNG8:product_logo_$size.png
done

mkdir -p "${icons_default200}"
cd "${icons_default200}"
for size in 16 32
do
    rsvg-convert -w $((size*2)) -h $((size*2)) -o "product_logo_${size}.png" "${svg_path}"
done
