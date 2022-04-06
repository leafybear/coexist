#!/bin/sh

# NAME the backup
name="library"
# WHAT to backup
from="$HOME/"
# WHERE to backup to
backupVolume="/Volumes/Kitty/backups/archives"
# specify somewhere to put the current archive symlink
linkLocation="/Volumes/Kitty/backups"
# OPTIONS
exclude="exclude/exclude.txt"
include="exclude/library-include.txt"
restore="exclude/library-restore.txt"
# 1 - keep directories synced, delete removed files
# 0 - backup incrementally by date, using hardlinks between backups
sync=0

source core.sh
