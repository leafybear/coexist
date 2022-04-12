# :::::::::::::::::::::::::::::::::::::::::::
#  Mini Sync
#  rsync synchronisation for a mac and portable SSD
# 
#  A. Bentley (leafybear@icloud.com)
#  2022
# :. : . : . : . : . : . : . : . : . : . : .:.

#
#	Use this on the macOS machine. For sharing data between a mac
#	and iPads that work off the same portable SSD.
#	Optional: connect a remote location to sync with this drive
#	as well.
#	Change the settings below:
#

#::: USER SETTINGS ::::::::::::::::::::
# the name of the removable volume we sync with
driveName="Starlight"
# the path on the volume we sync with
drivePath="amy"
# the local path to sync for macOS
macPath="$HOME/amy/"
# the local path to Coexist (so we can find the exclude files)
coexistPath="$HOME/amy/grimoire/proj.coexist"
#::: OPTIONAL REMOTE  ::::::::::::::::::
# a remote path you want to sync
remote="amy@Viridian.local:/mnt/archive/"
# where should it go on the drive?
remoteOnDrive="archive"
############################################

logo () {
	echo "        ____  _  _  __ _   ___ "
	echo " Mini  / ___)( \/ )(  ( \ / __)"
	echo "       \___ \ )  / /    /( (__ "
	echo "       (____/(__/  \_)__) \___)"
}

div () {
	printf "\033[0;31m . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .\033[0m\n"
}

cyprint () { # display a message in cyan ($1) and white ($2)
	printf "\033[0;36m%s \033[0m%s\n" "$1" "$2"
}

grprint () { # display a message in green ($1) and white ($2)
	printf "\033[0;32m%s \033[0m%s\n" "$1" "$2"
}

yeprint () { # display a message in yellow
	printf "\033[0;33m%s\033[0m\n" "$1"
}

err () { # display a warning orange and quit
	printf "\033[0;31m%s\033[0m\n" "$1"
	exit
}

local=$macPath
drive="/Volumes/$driveName/$drivePath"
remoteOnDrive="/Volumes/$driveName/$remoteOnDrive"
doRemote=false

if ! [ -d $local ]; then
	err "Local path '$local' doesn't exist. exiting."
fi

if ! [ -d $drive ]; then
	err "Drive path '$drive' not available. exiting."
fi

if ! [ -d $coexistPath ]; then
	err "Coexist folder not found at '$coexistPath'. exiting."
fi

if ! [ -z $remotePath ] && ! [ -z remoteOnDrive ]; then
	if ! [ -d $remoteOnDrive ]; then
		err "Drive path $remoteOnDrive doesn't exist. exiting."
	fi
fi

cd $coexistPath

# Get the exclude file contents
exclude1="all.exclude"
if ! [ -f "$exclude1" ]; then
    err "Exclude file $exclude1 doesn't exist, exiting."
fi

# Get the exclude file contents
exclude2="island.exclude"
if ! [ -f "$exclude2" ]; then
    err "Exclude file $exclude2 doesn't exist, exiting."
fi

logo
echo
cyprint " Drive:" "$drive"
cyprint " Local:" "$local"
cyprint " Remote:" "$remote"

args="-av --delete --exclude-from $exclude1 --exclude-from $exclude2"
from=
to=

while :
do
	case $1 in
		push ) # Push Changes
			grprint " Pushing to:" "$driveName"
			from=$local
			to=$drive
			remoteFrom=$remote
			remoteTo=$remoteOnDrive
			shift
			;;
		pull ) # Get Changes
			grprint " Pulling to:" "$driveName"
			from=$drive
			to=$local
			remoteFrom=$remoteOnDrive
			remoteTo=$remote
			shift
			;;
		dry ) # test settings in safe mode
			yeprint "   dry-run."
			args="$args -n"
			shift
			;;
		force ) # perform sync with --force
			yeprint "   using FORCE."
			args="$args --force"
			shift
			;;
		all ) # do both sync jobs
			yeprint "   performing optional sync"
			doRemote=true
			shift
			;;
		help ) # no more arguments
			echo ""
			echo "  No options chosen! Try again with one of the below."
			echo "    push - send changes to the drive"
			echo "    pull - get changes from drive"
			echo "    dry - perform a dry-run sync, no real changes"
			echo "    force - use force to remove files"
			echo "    all - sync both the local and remote folders with the drive"
			echo ""
			exit
			;;
		* ) # no more arguments
			break
			;;
	esac
done

div
echo
grprint " Syncing local:" "rsync $args $from $to"
echo
rsync $args $from $to
echo
grprint " local complete."
if $doRemote; then
	div
	echo
	grprint " Syncing remote:" "rsync $args $remoteFrom $remoteTo"
	echo
	rsync $args $remoteFrom $remoteTo
	echo
	grprint " remote complete."
fi

echo
