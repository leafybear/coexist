#!/bin/sh

# NAME the backup
name="documents"
# WHAT to backup
from="/Volumes/Plum/documents/"
# WHERE to backup to
backupVolume="/Volumes/Archive/backups"
# specify somewhere to put the current archive symlink
linkLocation="/Volumes/Archive"
# OPTIONS
exclude="exclude/exclude"
include=
restore=
# 1 - keep directories synced, delete removed files
# 0 - backup incrementally by date, using hardlinks between backups
sync=0

source backup.sh
