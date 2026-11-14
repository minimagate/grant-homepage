#!/bin/sh
# Exports index.tm to index.html with TeXmacs.
#
# The document is written in TeXmacs with the generic style; this only exports it. TeXmacs
# runs headless with its stock resources and a profile of its own (.texmacs/, not committed),
# so the export does not depend on personal settings. A PDF is exported first: that typesets
# the document, which is what resolves the references.
set -e
cd "$(dirname "$0")"
APP=${TEXMACS_APP:-/Applications/TeXmacs.app}
export TEXMACS_PATH="$APP/Contents/Resources/share/TeXmacs"
export TEXMACS_HOME_PATH="$PWD/.texmacs"
rm -f index-*.png
"$APP/Contents/MacOS/TeXmacs" -headless -x "(begin
  (set-preference \"texmacs->html:mathjax\" \"on\")
  (set-preference \"texmacs->html:images\" \"off\")
  (load-buffer (string->url \"$PWD/index.tm\"))
  (export-buffer-main (current-buffer) (string->url \"$PWD/grant.pdf\") \"pdf\" (list :overwrite))
  (export-buffer-main (current-buffer) (string->url \"$PWD/index.html\") \"html\" (list :overwrite))
  (quit-TeXmacs))" 2>&1 | grep -v "^TeXmacs\]" || true
test -s index.html && echo "exported index.html, grant.pdf and $(ls index-*.png | wc -l | tr -d ' ') figures"
