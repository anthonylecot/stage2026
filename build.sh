#!/bin/bash
set -e

BUNDLE="/opt/homebrew/opt/ruby/bin/bundle"
REPO="/Users/I058290/SAPDevelop/git/stage2026/site-animateur"
PUBLIC_OUT="/Users/I058290/SAPDevelop/git/stage2026_public"

cd "$REPO"

echo "=== Build SAP (baseurl /pages/i058290/stage2026) ==="
$BUNDLE exec jekyll build --destination /tmp/stage2026_sap

echo "=== Build public (baseurl /stage2026) ==="
$BUNDLE exec jekyll build --baseurl "/stage2026" --destination "$PUBLIC_OUT"

echo "=== Copie HTML SAP dans le repo ==="
cp /tmp/stage2026_sap/index.html "$REPO/index.html"
cp /tmp/stage2026_sap/checklist.html "$REPO/checklist.html"
cp /tmp/stage2026_sap/ateliers/*.html "$REPO/ateliers/"
cp -r /tmp/stage2026_sap/assets "$REPO/"
rm -rf /tmp/stage2026_sap

echo "=== Push SAP (origin) ==="
git add index.html checklist.html ateliers/*.html assets/
git diff --cached --quiet && echo "Rien à committer pour SAP" || git commit -m "Build SAP"
git push origin main

echo "=== Copie HTML public dans le repo ==="
cp "$PUBLIC_OUT/index.html" "$REPO/index.html"
cp "$PUBLIC_OUT/checklist.html" "$REPO/checklist.html"
cp "$PUBLIC_OUT/ateliers/"*.html "$REPO/ateliers/"
cp -r "$PUBLIC_OUT/assets" "$REPO/"

echo "=== Push public ==="
git add index.html checklist.html ateliers/*.html assets/
git diff --cached --quiet && echo "Rien à committer pour public" || git commit -m "Build public"
git push public main

echo "=== Done ==="
