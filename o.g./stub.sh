#!/bin/sh

# NAME the backup
name="ssh stuff"
# WHAT to backup
from="$HOME/.ssh/"
# WHERE to backup to
backupVolume="$HOME/name with spaces"
# specify somewhere to put the current archive symlink
linkLocation=
# OPTIONS
exclude="exclude/exclude.txt"
include=
restore=
# 1 - keep directories synced, delete removed files
# 0 - backup incrementally by date, using hardlinks between backups
sync=1

source core.sh
