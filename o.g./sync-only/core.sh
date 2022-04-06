### RSYNC BACKUP & RESTORE SCRIPT
#options:
#    -h  show this help
#    -s  run in safe mode - no changes will be made
#    -r 	restore the files to their origin"

rsyncArgs="-avhP --delete"

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

echo "Running in SYNC mode. Will delete any removed files from the archive."

to="$backupVolume/$name/"

# process any command flags
while :
do
	case $1 in
		-r ) # restore the backup
			oldFrom="$from"
			from="$to/"
			to="$oldFrom"
			rsyncArgs="$rsyncArgs $restore"
			include=
			exclude=
			shift
			;;
		-s ) # run in safe mode
			echo "THIS IS A TEST. no files will be changed."
			rsyncArgs="$rsyncArgs -n"
			shift
			;;
		* ) # no more arguments
			break
			;;
	esac
done

# # # # #   RUN RSYNC COMMAND
rsyncArgs="$rsyncArgs $exclude $include"
echo "About to backup, using:\nrsync $rsyncArgs $from $to"
rsync $rsyncArgs $from "$to"
echo "Completed backup from $from to $to"
# # # # #