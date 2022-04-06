#!/bin/sh

# NAME the backup
name="apps"
# WHAT to backup
from="/Applications/"
# WHERE to backup to
backupVolume="/Volumes/Whale/"
# specify somewhere to put the current archive symlink
linkLocation=""
# OPTIONS
exclude="exclude/exclude.txt"
include="exclude/apps-exclude.txt"
restore=
# 1 - keep directories synced, delete removed files
# 0 - backup incrementally by date, using hardlinks between backups
sync=1

source core.sh
