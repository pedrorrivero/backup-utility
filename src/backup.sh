#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 3 2019
# ---------------------------------------- #

TEST_SOURCE='../test'
TEST_BACKUP='../test.backup'

DIRECTORY_PAIRS=" $TEST_SOURCE $TEST_BACKUP "


## ---- LIBRARIES ---- ##

source './lib/logs.sh'
source './lib/parsing.sh'
source './lib/functions.sh'
source './lib/filesystem.sh'


## ---- MAIN  ---- ##

backup () {

  local ARGS=$@

  init_backup_mode
  argument_parser $ARGS
  create_log_file

  for (( i=0; i<${#DIRECTORY_PAIRS[@]}; i+=2 ));
  do

    local SOURCE_DIR=$(fix_dir_path ${DIRECTORY_PAIRS[$i]})
    local BACKUP_DIR=$(fix_dir_path ${DIRECTORY_PAIRS[$i+1]})

    override_requested_subdirecrories $SOURCE_DIR $BACKUP_DIR
    wipe_backup_if_requested $BACKUP_DIR

    do_backup $SOURCE_DIR $BACKUP_DIR
  done

  end_backup_mode

}


## ---- EXECUTION ---- ##

backup $@
# get_backup_path './test/dir1' './test' './test.backup/'