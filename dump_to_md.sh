#!/bin/bash
case "$PWD" in *ArchiveSafe*) echo "Protected zone - automation blocked"; exit 0;; esac
