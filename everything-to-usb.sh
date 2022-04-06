rsync -av --delete --exclude-from island.exclude --no-perms --no-owner --no-group --no-times --no-links --inplace --progress /home/amy/ /mnt/usb/everything/home/
rsync -av --delete --exclude=".*" --no-perms --no-owner --no-group --no-times --no-links --inplace --progress /mnt/archive/ /mnt/usb/everything/archive/
