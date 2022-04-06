ls -l | awk '{print $9}' | grep backup

ls -l | awk '{print $9}' | grep backup | awk 'END {print NR}'

ls -l | awk '{print $9}' | grep dots | awk '{split($0,a,"-"); print a[2], a[3]}'

ls -l | awk '!/current/' | awk 'END{print}'