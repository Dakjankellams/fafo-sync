#!/usr/bin/env bash
set -euo pipefail

LOGDIR="$HOME/fafo-sync/logs"
OUTBOX="$HOME/fafo-sync/outbox"
BACKUPDIR="$HOME/ios-backups"
MOUNTDIR="$HOME/ios-mount"

mkdir -p "$LOGDIR" "$OUTBOX" "$BACKUPDIR" "$MOUNTDIR"

LOGFILE="$LOGDIR/backup-ios-$(date -Iseconds).log"
echo "[+] iOS Backup Start $(date -Iseconds)" | tee -a "$LOGFILE"

echo "[+] Running idevicebackup2 backup" | tee -a "$LOGFILE"
idevicebackup2 backup "$BACKUPDIR" | tee -a "$LOGFILE"

echo "[+] Unmounting stale mount" | tee -a "$LOGFILE"
fusermount -u "$MOUNTDIR" 2>/dev/null || true

echo "[+] Mounting backup" | tee -a "$LOGFILE"
ifuse "$MOUNTDIR" --documents com.apple.itunesstored | tee -a "$LOGFILE"

ARTDIR="$OUTBOX/ios-$(date -Iseconds)"
mkdir -p "$ARTDIR"
cp -r "$MOUNTDIR" "$ARTDIR/mounted" | tee -a "$LOGFILE"

echo "[+] Unmounting" | tee -a "$LOGFILE"
fusermount -u "$MOUNTDIR" 2>/dev/null || true

echo "[✓] iOS Backup Finished → $ARTDIR" | tee -a "$LOGFILE"
