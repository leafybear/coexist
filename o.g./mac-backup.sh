#!/bin/sh
# PREPARE FOR MAC ERASE
#./sync-scripts2data.sh
./backup-data.sh
./backup-library.sh
./sync-apps2archive.sh
# get any extra data in desktop or downloads
rsync -avhP $HOME/Downloads/ /Volumes/Whale/backups/archives/downloads
rsync -avhP $HOME/Desktop/ /Volumes/Whale/backups/archives/desktop
