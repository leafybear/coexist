#!/bin/sh

# NAME the backup
name="applescripts"
# WHAT to backup
from="$HOME/Library/Scripts/"
# WHERE to backup to
backupVolume="/Users/amy/Documents/code/scripts/applescripts"

# OPTIONS
exclude="exclude/exclude.txt"
include=
restore=
# 1 - keep directories synced, delete removed files
# 0 - backup incrementally by date, using hardlinks between backups
sync=1

source core.sh
