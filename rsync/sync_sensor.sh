#!/bin/bash

sync () {
	rsync -e ssh -avz --delete-after --progress $1 jim@10.1.1.136:$2
}

if [[ $# -eq 0 ]] || [[ $# -gt 2 ]]; then
    echo 'Please enter either one or two arguments indicating the paths of the folder to be synced'
    echo 'Example: $ ./sync.sh /path/to/sync_directory_on_local_and_remote'
    echo 'Example: $ ./sync.sh /path/to/sync_directory_local /path/to/sync_directory_remote'
    exit 0
fi

ARG=$(readlink -f "$1")"/"

if [[ $# -eq 1 ]]; then
    temp1=${ARG%/}
    DST=${temp1%/*}"/"
    ONEARG=true
elif [[ $# -eq 2 ]]; then
    temp2=${2%/}
    DST=${temp2%/*}"/"
    ONEARG=false
fi

if [ "$ONEARG" = true ]; then
    if  [ ${ARG::9} = "/home/jim" ]; then
        echo "Syncing $ARG in local with $DST in remote."
		sync "$ARG" "$DST"
    else
        echo 'Syncing folders not in /home/jim is unpredictable. Use scripts with two arguments if you still wanna proceed with syncing.'
        echo 'Aborting'
    fi
else
    if  [ ${DST::9} = "/home/jim" ]; then
        echo "Syncing $ARG in local with $DST in remote."
		sync "$ARG" "$DST"
    else
        echo 'Does jim have permission to write in $DST ?'
        read -p "y/n" yn
    	case $yn in
        	[Yy]* ) echo "Syncing $ARG in local with $DST in remote."; sync "$ARG" "$DST"; break;;
        	[Nn]* ) exit;;
        	* ) echo "Please answer yes or no.";;
    	esac 
    fi
fi
