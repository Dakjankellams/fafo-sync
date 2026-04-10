#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/fafo-sync"
OUTBOX="$REPO_DIR/outbox"
LOGDIR="$REPO_DIR/logs"

mkdir -p "$REPO_DIR" "$OUTBOX" "$LOGDIR"

LOGFILE="$LOGDIR/sync-$(date -Iseconds).log"
echo "[+] FAFO Sync Start $(date -Iseconds)" | tee -a "$LOGFILE"

cd "$REPO_DIR"
git pull --no-edit | tee -a "$LOGFILE"

mkdir -p ingest
rsync -av --remove-source-files "$OUTBOX"/ ingest/ 2>/dev/null | tee -a "$LOGFILE"

COUNT=$(ls ingest 2>/dev/null | wc -l)
echo "[+] Files moved: $COUNT" | tee -a "$LOGFILE"

if ! git diff --quiet
then
    git add ingest | tee -a "$LOGFILE"
    git commit -m "ingest sync $(date -Iseconds)" | tee -a "$LOGFILE"
    git push | tee -a "$LOGFILE"
    echo "[+] Changes pushed" | tee -a "$LOGFILE"
else
    echo "[i] No changes to commit" | tee -a "$LOGFILE"
fi

echo "[✓] FAFO Sync Complete" | tee -a "$LOGFILE"
