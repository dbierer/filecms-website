#!/bin/bash
DIR=`pwd`
export USAGE="Usage: init.sh up|down|build|ls|demo|shell"
export CONTAINER="file_cms"
export INIT=0
if [[ -z "$1" ]]; then
    echo $USAGE
    exit 1
elif [[ "$1" = "up" ||  "$1" = "start" ]]; then
    docker-compose up -d $2
elif [[ "$1" = "down" ||  "$1" = "stop" ]]; then
    docker-compose down
    sudo chown -R $USER:$USER *
    sudo chmod -R 775 .*
    rm 1
elif [[ "$1" = "build" ]]; then
    docker-compose build $2
elif [[ "$1" = "ls" ]]; then
    docker container ls
elif [[ "$1" = "shell" ]]; then
    docker exec -it $CONTAINER /bin/bash
elif [[ "$1" = "demo" ]]; then
    php composer.phar self-update
    php composer.phar install
    php -S localhost:8888 -t public
else
    echo $USAGE
    exit 1
fi
exit 0
