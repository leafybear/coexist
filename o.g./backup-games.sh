#!/bin/sh

# NAME the backup
name="games"
# WHAT to backup
from="/Users/amy/Games/"
# WHERE to backup to
backupVolume="/Volumes/Kitty/backups/archives"
# specify somewhere to put the current archive symlink
linkLocation="/Volumes/Kitty/backups"
# OPTIONS
exclude="exclude/exclude.txt"
include=
restore=
# 1 - keep directories synced, delete removed files
# 0 - backup incrementally by date, using hardlinks between backups
sync=1

source core.sh
