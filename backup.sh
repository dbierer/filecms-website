#!/bin/bash
export BASE_DIR=/repo
# backup HTML
export HTML_DIR=`php $BASE_DIR/src/get_info_from_config.php html_dir`
export BACKUP_DIR=`php $BASE_DIR/src/get_info_from_config.php backup_dir`
export BACKUP_FN=$BACKUP_DIR/templates.zip
export BACKUP_DAILY_FN=$BACKUP_DIR/templates_`date +%Y_%a`.zip
export BACKUP_MONTHLY_FN=$BACKUP_DIR/templates_`date +%Y_%b`.zip
zip -r $BACKUP_FN $HTML_DIR/*
cp $BACKUP_FN $BACKUP_DAILY_FN
cp $BACKUP_FN $BACKUP_MONTHLY_FN
