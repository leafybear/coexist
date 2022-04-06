#!/bin/sh

date=`date "+%Y.%m.%d"`
time=`date "+%H.%M"`

rsync -aP --link-dest=/Volumes/Olympus/delphi__current /Volumes/Delphi/ /Volumes/Olympus/delphi__$date__$time
rm -f /Volumes/Olympus/delpi__current
ln -s /Volumes/Olympus/delphi__$date__$time /Volumes/Olympus/delphi__current