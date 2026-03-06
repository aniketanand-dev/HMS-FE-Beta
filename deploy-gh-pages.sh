#!/usr/bin/env bash
set -euo pipefail

BASE_PATH="${1:-/HMS-FE-Beta/}"
AUTO_COMMIT="${2:-false}"
AUTO_PUSH="${3:-false}"

if [[ ! "$BASE_PATH" =~ ^/.*?/$ ]]; then
  echo "Error: base path must look like /repo-name/"
  echo "Example: ./deploy-gh-pages.sh /HMS-FE-Beta/"
  exit 1
fi

echo "Applying base href=${BASE_PATH} to all HTML files..."
find . -name "*.html" -type f -exec sed -i "s|<base href=\"/\">|<base href=\"${BASE_PATH}\">|g" {} +

echo "Done. Updated files are ready."

if [[ "$AUTO_COMMIT" == "true" ]]; then
  git add .
  if git diff --cached --quiet; then
    echo "No changes to commit."
  else
    git commit -m "chore: set base href to ${BASE_PATH} for GitHub Pages"
    echo "Committed changes."
  fi

  if [[ "$AUTO_PUSH" == "true" ]]; then
    git push
    echo "Pushed to remote."
  else
    echo "Skipped push. Run: git push"
  fi
else
  echo "Skipped commit/push."
  echo "To commit manually: git add . && git commit -m \"chore: set base href\" && git push"
fi

echo "Open: https://aniketanand-dev.github.io${BASE_PATH}"
