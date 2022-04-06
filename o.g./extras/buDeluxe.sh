#!/bin/sh

#### USAGE
if [ "$#" -lt 2 ]; then
		echo
		echo "Backup Deluxe 0.1  by fidgetfu. quick and easy rsync backups."
		echo "-----------------------------"
		echo "USAGE $ ./buDeluxe.sh --options /Path/to/my/files /Drive/to/store/backups"
		echo "you must provide full paths to the source and target directories"
		echo
		echo "OPTIONS"
		echo "  --safe     dry-run mode only. no files will be touched."
		echo "  --label X  store the backup with this name instead of the folder name."
		echo "  --library  backup the os x library items specified in $HOME/.rsync-library-include"
		echo
		echo "EXAMPLES"
		echo "$  ./buDeluxe.sh --library /Volumes/Olympus/"
		echo "backup my mac Library folder items'"
		echo "$  ./buDeluxe.sh --safe /User/amy/Dropbox/ /Volumes/Olympus/"
		echo "run a test backup of the dropbox folder. no files will be copied."
		exit
fi
#____________________________

####  Set up for script
# get nice format date and time
date=`date "+%Y.%m.%d-%H.%M"`

# include/exclude paths
excludeFile="$HOME/.rsync-exclude"
libraryIncludeFile="$HOME/.rsync-library-include"

# basic command to run
rsyncArgs="-avhP"
if [ -f excludeFile ]; then # only add this if the exclude file exists.
	rsyncArgs="$rsyncArgs --exclude-from $excludeFile"
fi

#____________________________

#### Consider arguments
safe_run=0
target=
targetPath=

while :
do
	case $1 in
		--library | -b ) # use the mac library as the target
			if [ -f libraryIncludeFile ]; then # only add this if the exclude file exists.
				targetPath="$HOME/Library/"
				rsyncArgs="$rsyncArgs --include-from $libraryIncludeFile"
				echo "Including library files found in: $libraryIncludeFile"
				shift
			else
				echo "There is NO LIBRARY INCLUDE FILE"
				exit 0
			fi			
			;;
		--safe | -s ) # just run in test mode. do nothing to files
			echo "! ! ! >>> THIS IS A DRILL. <<< ! ! !    no files will be changed."
			rsyncArgs="$rsyncArgs -n"
			safe_run=1
			shift
			;;
		--label | -l ) # set the label another way
			target=$2
			shift 2
			;;
		--label=* | -l=*) # set the label of the backup
			target=${1#*=}
			shift
			;;
		-* ) # warn of unknown option
			echo "unknown option (ignored): $1" >&2
			shift
			;;
		* ) # no more options. stop loop
			break
			;;
	esac
done

if [ -z $targetPath ]; then
	targetPath="$1"
	shift
fi

backupDestination="$1" # last argument
echo "Backup deluxe: about to backup $targetPath to $backupDestination"

if [ -z $target ]; then
	# get the last folder of the target path
	target=`echo $targetPath | grep -Eo '[^/]+/?$' | cut -d / -f1`
	# change it to lower case
	target=`echo $target | tr '[:upper:]' '[:lower:]'`
fi
echo "Setting backup name to: $target"

# append the date
backupName="$backupDestination$target-$date"
# make the current link name
linkName="$backupDestination$target-current"
# comment out spaces
backupName=`echo "$backupName" | sed 's/ /\\ /g'`
linkName=`echo "$linkName" | sed 's/ /\\ /g'`
#____________________________


#### RUN RSYNC COMMAND
# see if we've backed up before
linkArgs=
if [ -d "$linkName" ]; then
	rm -f "$linkName"
	linkArgs="--link-dest=$linkName"
	linkArgs=`echo "$linkArgs" | sed 's/ /\\ /g'`
fi
# run the backup!
echo "About to run RSYNC command:"
echo $rsyncArgs $linkArgs $targetPath $backupName
rsync $rsyncArgs "$linkArgs" "$targetPath" "$backupName"
# create the new symlink
if [ $safe_run -eq 0 ]; then
	ln -s "$backupName" "$linkName"
fi


# FIN