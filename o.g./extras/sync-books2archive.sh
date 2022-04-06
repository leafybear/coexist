#!/bin/sh

# NAME the backup
name=""
# WHAT to backup
from="/Volumes/Media/Books/"
# WHERE to backup to
backupVolume="/Volumes/Archive/backups/media/books/"
# specify somewhere to put the current archive symlink
linkLocation=""
# OPTIONS
exclude="exclude/exclude.txt"
include=
restore=
# 1 - keep directories synced, delete removed files
# 0 - backup incrementally by date, using hardlinks between backups
sync=1

source core.sh
