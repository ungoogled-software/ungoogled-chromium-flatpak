This icon was created by the GitHub user "SecularSteve": https://github.com/SecularSteve
who participated in the following GitHub discussion thread:
https://github.com/ungoogled-software/ungoogled-chromium/discussions/1756

Previously, the icon was compliant with the guidelines set by Flathub referenced here:
https://docs.flathub.org/docs/for-app-authors/metainfo-guidelines/quality-guidelines/#reasonable-footprint
However, this was undone and it now fills the entire canvas again. This is because
Chromium's SVG fills the entire canvas and I don't want to introduce any potential
issues of the icon being too small. When not used just as a .desktop icon but in
the browser proper as part of the branding, it will be used for tiny stuff like the
browser icon in the "Task Manager" window and other places and if the icon does not
fill the entire canvas it will just look very bad.

The dimensions to revert to the kosher Flathub rules are to set the X/Y to 4/4
and H/W to 120/120 for `Layer 1` in `logo.svg`. Afterwards, just re-run
`generate.sh` which is in the same directory as this README.txt file.
