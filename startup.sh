#!/bin/bash
export VER=81

# making link to php
ln -s /usr/bin/php81 /usr/bin/php

# Composer
echo "Checking Composer setup ..."
cd /repo
php composer.phar self-update
php composer.phar update

# Setting up nginx
mv /var/www/html /var/www/html.OLD
ln -s /repo/public /var/www/html

# Assigning permissions
cd /repo
chgrp -R nobody *

# Start the first process
/usr/sbin/php-fpm$VER
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start php-fpm: $status"
  exit $status
fi
echo "Started php-fpm succesfully"

# Start the second process
/usr/sbin/nginx
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start nginx: $status"
  exit $status
fi
echo "Started nginx succesfully"

# Naive check runs checks once a minute to see if either of the processes exited.
# This illustrates part of the heavy lifting you need to do if you want to run
# more than one service in a container. The container exits with an error
# if it detects that either of the processes has exited.
# Otherwise it loops forever, waking up every 60 seconds

while sleep 60; do
  ps |grep php-fpm$VER |grep -v grep
  PROCESS_1_STATUS=$?
  ps |grep nginx |grep -v grep
  PROCESS_2_STATUS=$?
  # If the greps above find anything, they exit with 0 status
  # If they are not both 0, then something is wrong
  if [ -f $PROCESS_1_STATUS -o -f $PROCESS_2_STATUS ]; then
    echo "One of the processes has already exited."
    exit 1
  fi
done
