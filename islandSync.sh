# :::::::::::::::::::::::::::::::::::::::::::
#  Island Sync
#  rsync synchronisation for multiple PCs
# 
#  A. Bentley (leafybear@icloud.com)
#  2022
# :. : . : . : . : . : . : . : . : . : . : .:.

#
#	Use this on the island machines, not the mainland.
#	Then whenever you're on the main one it is always up
#	to date. Change the settings below:
#

#::: USER SETTINGS ::::::::::::::::::::
# the remote is the hub for your data sync.
remoteHost="Viridian"
# the path on the remote we want to be in sync with
remotePath="~/"
# the local path to sync when in linux
linuxLocal="$HOME/"
# the local path to sync for macOS
macLocal="$HOME/amy/"
# the local path to Coexist (so we can find the exclude files)
coexistPath="grimoire/proj.coexist"
############################################

echo "Island Sync . . . . . . . . . . . . . . . . . . . . . . ."
echo "  "

local=$linuxLocal

# Use macOS paths and names
if [[ `uname` == Darwin ]]; then
  local=$macLocal
  remoteHost="$remoteHost.local"
  echo "  found macOS."
  coexistPath="amy/$coexistPath"
fi

coexistPath="$HOME/$coexistPath"
cd $coexistPath

remote="$remoteHost:$remotePath"

# Get the exclude file contents
exclude1="all.exclude"
if ! [ -f "$exclude1" ]; then
    echo "exclude file $exclude1 doesn't exist, exiting."
	exit
fi

# Get the exclude file contents
exclude2="island.exclude"
if ! [ -f "$exclude2" ]; then
    echo "exclude file $exclude2 doesn't exist, exiting."
	exit
fi

echo "  exclude files loaded."
echo "  remote is $remote"
echo "  local is $local"
args="-av --delete --exclude-from $exclude1 --exclude-from $exclude2"
from=
to=

while :
do
	case $1 in
		push ) # Push Changes
			echo "  pushing changes to remote $remoteHost"
			from=$local
			to=$remote
			shift
			;;
		pull ) # Get Changes
			echo "  pulling changes from $remoteHost."
			from=$remote
			to=$local
			shift
			;;
		dry ) # test settings in safe mode
			echo "  doing a dry-run."
			args="$args -n"
			shift
			;;
		force ) # perform sync with --force
			echo "  using FORCE."
			args="$args --force"
			shift
			;;
		# tidy ) # test settings in safe mode
		# 	echo "  deleting excluded files and folders."
		# 	args="$args --delete-excluded"
		# 	shift
		# 	;;
		help ) # no more arguments
			echo ""
			echo "  No options chosen! Try again with one of the below."
			echo "    push - send changes to the hub"
			echo "    pull - get changes from hub"
			echo "    dry - perform a dryn-run sync, no real changes"
#			echo "    tidy - delete the excluded files and folders"
			echo "    force - use force to remove files"
			echo ""
			exit
			;;
		* ) # no more arguments
			break
			;;
	esac
done

echo "  preparing: rsync $args $from $to"
# reachable=$(ping -c 1 $remoteHost 2>&1 >/dev/null)
# if [ $reachable -ne 0 ]; then
# 	echo "can't reach remote $remoteHost. exiting."
# 	echo ""
# 	exit
# fi

echo ""
rsync $args $from $to
echo ""
echo " sync complete. . . . . . . . . . . . . . . . . . . ."
echo ""
