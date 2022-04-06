#!/bin/sh
# RESTORE CRITICAL MAC DATA
./backup-data.sh -r
./backup-library.sh -r
./sync-apps2archive.sh -r
./syn-scripts2data.sh -r
# get any extra data in desktop or downloads
rsync -avhP /Volumes/Whale/backups/archives/downloads/ $HOME/Downloads/
rsync -avhP /Volumes/Whale/backups/archives/desktop/ $HOME/Desktop/
