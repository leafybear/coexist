#!/bin/sh

# Usage message
usage="$(basename "$0") [-hsirdct] -- rsync backup utility
\n
\ncommands
\n  run without arguments to copy files
\n    -h  show this help
\n 	  -s sync
\n    -i increment
\n    -r restore (reverse direction)
\n    -c check backups
\noptions
\n    -d trim excluded files
\n    -t test settings"

# include="$from/.rsync_include"
# exclude="$from/.rsync_exclude"
# restore="$from/.rsync_restore"
linkToLatest="$to/latest"
now=`date "+%Y-%m-%d @ %H.%M"`
args="-avhP"
makeLink=0

# TEST SANITY OF FILE PATHS
# if any folders or files don't exist, exit with message
if ! [ -d "$from" ]; then
	echo "Directory doesn't exist.: $from"
	exit
fi
if ! [[ "$to" == *"@"* ]]; then
	if ! [ -d "$to" ]; then
		echo "Directory doesn't exist.: $to"
		exit
	fi
fi
if [ -f "$exclude" ]; then
	exclude="--exclude-from $exclude"
else
	exclude=
fi
if [ -f "$include" ]; then
	include="--include-from $include"
else
	include=
fi
if [ -f "$restore" ]; then
	restore="--include-from $restore"
else
	restore=
fi

# determine what kind of operation this is:
#- copy (default)
#- s sync
#- i increment
#- r restore (reverse direction)
#- d trim excluded files
#- c check backups
#- t test settings

while :
do
	case $1 in
		-h ) # show help then quit
			echo $usage
			exit
			;;
		-d ) # delete files that are excluded in the exclude file
			echo "Deleting excluded files."
			args="$args --delete-excluded"
			shift
			;;
		-t ) # test settings in safe mode
			echo "THIS IS A TEST. no files will be changed."
			args="$args -n"
			shift
			;;
		-c ) # check the status of the backups
			echo "Checking state of backups for $from..."
			if [ $sync -eq 1 ]; then
				total=1
				recent=`ls -l $to | awk '{print $6, $7, $8}'`
			else
				total=`ls -l $to | awk '{print $9}' | awk '!/current/' | awk 'END {print NR}'`
				recent=`ls -l $to | awk '{print $9}' | awk '!/current/' | awk 'END {split($0,a," "); print a[2], "@ " a[3]}'`
			fi
			echo "$total backups.\nlast backed up on $recent."
			exit
			;;
		-s ) # synchronise folders
			echo "Synchronising."
			args="$args --delete"
			latest=
			shift
			;;
		-i ) # incremental backup
			echo "Beginning incremental backup."
			to="$to/$now"
			if [ -d "$linkToLatest" ]; then
				args="$args --link-dest=$linkToLatest"
			fi
			makeLink=1
			shift
			;;
		-r ) # restore the backup
			oldFrom="$from"
			if [ -d "$linkToLatest" ]; then
				from="$linkToLatest"
			else
				from="$to"
			fi
			to="$oldFrom"
			include="$restore"
			exclude=
			shift
			;;
		* ) # no more arguments
			break
			;;
	esac
done

# # # # #   RUN RSYNC COMMAND
args="$args $exclude $include"
echo "rsync $args $from $to"
rsync $args "$from/" "$to/"
echo "Completed backup from $from to $to"
# # # # #

# create the "current" symlink if applicable
if [ $makeLink -ne 0 ]; then
	# don't create if the backup didn't work
	echo "creating a symlink to the newest backup."
	echo "$linkToLatest"
	if [ -d "$to" ]; then
		rm -f $linkToLatest
		ln -s "$to" $linkToLatest
	fi
fi
echo "- - ---------    ---------- - -"

#
