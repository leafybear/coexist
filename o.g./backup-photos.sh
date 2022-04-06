#!/bin/sh

# NAME the backup
name="photos"
# WHAT to backup
from="/Users/amy/Pictures/"
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
sync=0

source core.sh
