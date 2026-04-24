#!/bin/bash
# push-list.sh — Run this (or add to cron) to push the latest grocery list to GitHub Pages
# Cron example (runs Sunday at 6am): 0 6 * * 0 /path/to/push-list.sh

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG="$REPO_DIR/push.log"

cd "$REPO_DIR" || exit 1

# Only commit if index.html actually changed
if git diff --quiet index.html && git ls-files --error-unmatch index.html &>/dev/null 2>&1 && ! git status --short | grep -q "index.html"; then
  echo "$(date): No changes to index.html, skipping." | tee -a "$LOG"
  exit 0
fi

git add index.html
git commit -m "Grocery list update $(date +%Y-%m-%d)" 2>&1 | tee -a "$LOG"
git push origin main 2>&1 | tee -a "$LOG"
echo "$(date): Push complete." | tee -a "$LOG"
