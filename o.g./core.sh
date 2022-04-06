### RSYNC INCREMENTAL BACKUP SCRIPT
usage="$(basename "$0") [-hsrcd] -- script to backup a folder with rsync
\n
\noptions:
\n    -h  show this help
\n    -s  run in safe mode - no changes will be made
\n    -r 	restore the files to their origin
\n    -c 	check the state of the backups for this folder
\n    -d 	delete any files in the backup that are listed in the exclude file"

rsyncArgs="-avhP"
echo "- - ---------RSYNC---------- - -"

# TEST SANITY OF FILE PATHS
# if any folders or files don't exist, exit with message
if ! [ -d "$from" ]; then
	echo "Directory doesn't exist.\n: $from"
	exit
fi
if ! [ -d "$backupVolume" ]; then
	echo "Directory doesn't exist.\n: $backupVolume"
	exit
fi
if [[ $exclude ]]; then
	if ! [ -f "$exclude" ]; then
		echo "Exclude file doesn't exist.\n: $exclude"
		exit
	else
		exclude="--exclude-from $exclude"
	fi
fi
if [[ $include ]]; then
	if ! [ -f "$include" ]; then
		echo "Include file doesn't exist.\n: $include"
		exit
	else
		include="--include-from $include"
	fi
fi
if [[ $restore ]]; then
	if ! [ -f "$restore" ]; then
		echo "Restore file doesn't exist.\n: $restore"
		exit
	else
		restore="--include-from $restore"
	fi
fi

# default rsync settings, changed if flags used
date=`date "+%Y.%m.%d-%H.%M"`
backupName="$name-$date"
linkName="$name"
to="$backupVolume/$backupName/"
makeLinks=1

# set alternate link location if desired
if [[ $linkLocation ]]; then
	linkLocation="$linkLocation/$linkName"
else
	linkLocation="$backupVolume/$linkName"
fi
link="--link-dest=$linkLocation"

# change values if sync requested in header
if [ $sync -eq 1 ]; then
	rsyncArgs="$rsyncArgs --delete"
	makeLinks=0
	link=
	to="$backupVolume/$name/"
fi

# process any command flags
while :
do
	case $1 in
		-r ) # restore the backup
			oldFrom="$from"
			if [ $sync -eq 1 ]; then
				from="$to"
			else
				from="$linkLocation/"
			fi
			to="$oldFrom"
			rsyncArgs="$rsyncArgs $restore"
			include=
			exclude=
			link=
			makeLinks=0
			shift
			;;
		-s ) # run in safe mode
			echo "THIS IS A TEST. no files will be changed."
			rsyncArgs="$rsyncArgs -n"
			makeLinks=0
			shift
			;;
		-d ) # delete files that are excluded in the exclude file
			rsyncArgs="$rsyncArgs --delete-excluded"
			shift
			;;
		-c ) # check the status of the backups
			echo "Checking state of backups for $name ($from)..."
			if [ $sync -eq 1 ]; then
				total=1
				recent=`ls -l $backupVolume | grep $name | awk '{print $6, $7, $8}'`
			else
				total=`ls -l $backupVolume | awk '{print $9}' | grep $name | awk '!/current/' | awk 'END {print NR}'`
				recent=`ls -l $backupVolume | awk '{print $9}' | grep $name | awk '!/current/' | awk 'END {split($0,a,"-"); print a[2], "@ " a[3]}'`
			fi
			echo "$total backup(s), last backed up on $recent"
			exit
			;;
		-h ) # show help then quit
			echo $usage
			exit
			;;
		* ) # no more arguments
			break
			;;
	esac
done

# if the linkname folder doesn't exist, remove the variable for it
if ! [ -d "$linkLocation" ]; then
	link=
fi

if [ $sync -eq 1 ]; then
	echo "Running in SYNC mode. Will delete any removed files from the archive."
fi

# # # # #   RUN RSYNC COMMAND
rsyncArgs="$rsyncArgs $exclude $include $link"
echo "About to backup, using:\nrsync $rsyncArgs $from $to"
rsync $rsyncArgs $from "$to"
echo "Completed backup from $from to $to"
# # # # #

# create the "current" symlink if applicable
if [ $makeLinks -ne 0 ]; then
	# don't create if the backup didn't work
	if [ -d "$backupVolume/$backupName" ]; then
		rm -f $linkLocation
		ln -s $backupVolume/$backupName $linkLocation
	fi
fi
echo "- - ---------    ---------- - -"
