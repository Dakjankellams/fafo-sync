#!/usr/bin/env bash
set -euo pipefail

source "$HOME/.fafo-sync.conf"

mkdir -p "$FAFO_OUTBOX_DIR" "$FAFO_INGEST_DIR" "$FAFO_LOG_DIR" "$HOME/fafo-repos"

LOGFILE="$FAFO_LOG_DIR/sync-$(date +%Y%m%d_%H%M%S).log"
exec >> "$LOGFILE" 2>&1

echo "[+] FAFO Sync Start $(date -Iseconds)"

if [ ! -d "$FAFO_REPO_DIR/.git" ]; then
  git clone "git@github.com:Dakjankellams/fafo-sync.git" "$FAFO_REPO_DIR"
fi

cd "$FAFO_REPO_DIR"

git pull --rebase origin main || git pull origin master || true

shopt -s nullglob
for f in "$FAFO_OUTBOX_DIR"/*; do
  [ -f "$f" ] || continue
  cp -f "$f" "$FAFO_INGEST_DIR"/
done

cp -f "$FAFO_INGEST_DIR"/* "$FAFO_REPO_DIR"/ingest/ 2>/dev/null || true

git add ingest
git commit -m "sync $(date -Iseconds)" || true
git push origin main || git push origin master || true

echo "[✓] FAFO Sync Complete"
