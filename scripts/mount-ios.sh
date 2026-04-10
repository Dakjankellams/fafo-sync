#!/usr/bin/env bash
set -euo pipefail

LOGDIR="$HOME/fafo-sync/logs"
MOUNTDIR="$HOME/ios-mount"

mkdir -p "$LOGDIR" "$MOUNTDIR"

LOGFILE="$LOGDIR/mount-ios-$(date -Iseconds).log"
echo "[+] iOS Mount Start $(date -Iseconds)" | tee -a "$LOGFILE"

echo "[+] Unmounting stale mount" | tee -a "$LOGFILE"
fusermount -u "$MOUNTDIR" 2>/dev/null || true

echo "[+] Mounting device Documents domain" | tee -a "$LOGFILE"
ifuse "$MOUNTDIR" --documents com.apple.itunesstored | tee -a "$LOGFILE"

echo "[✓] Mounted at $MOUNTDIR" | tee -a "$LOGFILE"
