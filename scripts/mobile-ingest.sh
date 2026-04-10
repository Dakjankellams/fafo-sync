#!/usr/bin/env bash
set -euo pipefail

LOGDIR="$HOME/fafo-sync/logs"
OUTBOX="$HOME/fafo-sync/outbox"
ANDROID_SRC="$HOME/android-dumps"
IOS_SRC="$HOME/ios-mount"

mkdir -p "$LOGDIR" "$OUTBOX" "$ANDROID_SRC"

LOGFILE="$LOGDIR/mobile-ingest-$(date -Iseconds).log"
echo "[+] Mobile Ingest Start $(date -Iseconds)" | tee -a "$LOGFILE"

ARTDIR="$OUTBOX/mobile-$(date -Iseconds)"
mkdir -p "$ARTDIR"

echo "[+] Copying Android artifacts" | tee -a "$LOGFILE"
cp -r "$ANDROID_SRC" "$ARTDIR/android" 2>/dev/null || true

echo "[+] Copying iOS artifacts" | tee -a "$LOGFILE"
cp -r "$IOS_SRC" "$ARTDIR/ios" 2>/dev/null || true

echo "[✓] Mobile Ingest Complete → $ARTDIR" | tee -a "$LOGFILE"
