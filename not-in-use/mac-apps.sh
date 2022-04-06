#!/bin/sh

# MAC OS APP BACKUP

from="/Applications"
to="/Volumes/Leaf/backups/apps"

include=
exclude="mac-apps.exclude"
restore=

source coexist.sh
