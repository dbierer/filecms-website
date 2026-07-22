#!/bin/bash
DIR=`pwd`
export USAGE="Usage: admin.sh up|down|build|ls|shell"
export CONTAINER="file_cms"
export INIT=0
if [[ -f /usr/bin/podman ]]; then
    export CMD=podman
elif
    export CMD=docker
fi

if [[ -z "$1" ]]; then
    echo $USAGE
    exit 1
elif [[ "$1" = "up" ||  "$1" = "start" ]]; then
    $CMD-compose up -d $2
elif [[ "$1" = "down" ||  "$1" = "stop" ]]; then
    $CMD-compose down
    sudo chown -R $USER:$USER *
    sudo chmod -R 775 .*
    rm 1
elif [[ "$1" = "build" ]]; then
    $CMD-compose build $2
elif [[ "$1" = "ls" ]]; then
    $CMD container ls
elif [[ "$1" = "shell" ]]; then
    $CMD exec -it $CONTAINER /bin/bash
else
    echo $USAGE
    exit 1
fi
exit 0
