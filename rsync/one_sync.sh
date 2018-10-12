#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'Please enter the absolute path to folder which you wanna sync with the remote servers.'
    echo 'Example: $ ./sync.sh /path/to/output_directory'
    exit 0
fi

ARG=${1%/}
if [[$# -eq 1]]
    DST=${ARG%/*}"/"
else if [[$# -eq 2]]
    temp=${2%/}
    DST=${temp%/*}"/"
fi

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

if [ ${ARG::9} = "/home/jim" ]  || [ ${ARG::10} = "/data4/jim" ]; then
    rsync -e ssh -avz --delete-after --progress $ARG jim@198.180.182.232:$DST
else
    echo 'Syncing folders not in home or /data4/ is unpredictable. If it is within ~/ or /data3, you have not provided the full path to the folder.'
    echo 'Aborting'
fi