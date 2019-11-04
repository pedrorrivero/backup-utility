#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

BIN_NAME='prr-backup'
LIB_NAME='src'
INSTALLATION_LOCATION='/usr/local/bin'

BIN_PATH="${INSTALLATION_LOCATION}/${BIN_NAME}"
LIB_PATH="${INSTALLATION_LOCATION}/${BIN_NAME}-${LIB_NAME}"

# THIS INIZIALIZATION CAN BE SET FOR AUTOMATED BACKUPS
if [ -e $LIB_PATH ]; then
  # AFTER CONFIGURATION THIS WILL BE USED
  DIRECTORY_PAIRS=$(cat "${LIB_PATH}/../preconfig-dirs" 2>/dev/null)
else
  # BEFORE CONFIGURATION THIS WILL BE USED
  DIRECTORY_PAIRS=$(cat "./preconfig-dirs" 2>/dev/null)
fi



## ---- LIBRARIES ---- ##

if [ -e $LIB_PATH ]; then
  # AFTER CONFIGURATION THIS WILL BE USED
  source "${LIB_PATH}/filesystem.sh"
  source "${LIB_PATH}/functionality.sh"
  source "${LIB_PATH}/logs.sh"
  source "${LIB_PATH}/parsing.sh"
else
  # BEFORE CONFIGURATION THIS WILL BE USED
  source "${LIB_NAME}/filesystem.sh"
  source "${LIB_NAME}/functionality.sh"
  source "${LIB_NAME}/logs.sh"
  source "${LIB_NAME}/parsing.sh"
fi


## ---- MAIN  ---- ##

backup () {

  local ARGS=$@

  init_backup_mode $ARGS

  for (( i=0; i<${#DIRECTORY_PAIRS[@]}; i+=2 ));
  do

    local SOURCE_DIR=${DIRECTORY_PAIRS[$i]}
    local BACKUP_DIR=${DIRECTORY_PAIRS[$i+1]}

    override_requested_subdirecrories $SOURCE_DIR $BACKUP_DIR
    wipe_backup_if_requested $BACKUP_DIR

    do_backup $SOURCE_DIR $BACKUP_DIR
  done

  end_backup_mode

}


## ---- EXECUTION ---- ##

backup $@
