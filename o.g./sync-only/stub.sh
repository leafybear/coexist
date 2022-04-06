#!/bin/sh

# _NAME_ the backup
# this will be the folder the backup data is inside
name="desktop"
# _WHAT_ to backup, use a trailing slash to backup 
# contents into destination folder
from="$HOME/Desktop/"
# _WHERE_ to backup to (no trailing slash)
# the backup folder will go inside here
backupVolume="$HOME/Downloads/test"

# OPTIONS, include = what to backup, restore = what to restore
exclude="includes/exclude.txt"
include=
restore=

source core.sh
