#!/bin/sh

# NAME the backup
name=""
# WHAT to backup
from="/Volumes/Users/jedip_000/Comics/"
# WHERE to backup to
backupVolume="/Volumes/Media/Comics/"

# OPTIONS
exclude="exclude/exclude.txt"
include=
restore=
# 1 - keep directories synced, delete removed files
# 0 - backup incrementally by date, using hardlinks between backups
sync=1

source core.sh
