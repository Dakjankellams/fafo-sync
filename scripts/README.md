# FAFO Sync Engine

A deterministic, cross-device ingestion and synchronization engine.

## Structure
scripts/  - all automation scripts
config/   - configuration files
logs/     - timestamped logs
outbox/   - artifacts waiting to sync
inbox/    - optional incoming queue
tmp/      - scratch space

## Workflow
1. Extract artifacts (iOS or Android)
2. Artifacts drop into outbox/
3. Run scripts/fafo-sync.sh
4. Engine pulls, ingests, commits, and pushes

## Logging
All logs stored in logs/ with timestamped filenames.
