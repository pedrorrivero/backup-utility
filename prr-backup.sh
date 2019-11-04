#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

BIN_NAME='prr-backup'
SRC_NAME='src'
LIB_NAME='lib'
INSTALLATION_LOCATION='/usr/local/bin'

BIN_PATH="${INSTALLATION_LOCATION}/${BIN_NAME}"
SRC_PATH="${INSTALLATION_LOCATION}/${BIN_NAME}-${SRC_NAME}"


## ---- PRECONFIGURED BACKUP DIRECTORIES ---- ##

# THIS INIZIALIZATION CAN BE SET FOR AUTOMATED BACKUPS
if [ -e $SRC_PATH ]; then
  # AFTER INSTALLATION THIS WILL BE USED
  DIRECTORY_PAIRS=$(cat "${SRC_PATH}/../preconfig-dirs" 2>/dev/null)
else
  # BEFORE INSTALLATION THIS WILL BE USED
  DIRECTORY_PAIRS=$(cat "./preconfig-dirs" 2>/dev/null)
fi


## ---- LIBRARIES ---- ##

if [ -e $SRC_PATH ]; then
  # AFTER INSTALLATION THIS WILL BE USED
  source "${SRC_PATH}/backup.sh"
  source "${SRC_PATH}/end.sh"
  source "${SRC_PATH}/init.sh"
  source "${SRC_PATH}/override.sh"
  source "${SRC_PATH}/wipe.sh"
  source "${SRC_PATH}/${LIB_NAME}/checkers.sh"
  source "${SRC_PATH}/${LIB_NAME}/etc.sh"
  source "${SRC_PATH}/${LIB_NAME}/getters.sh"
  source "${SRC_PATH}/${LIB_NAME}/loggers.sh"
  source "${SRC_PATH}/${LIB_NAME}/prompters.sh"
  source "${SRC_PATH}/${LIB_NAME}/setters.sh"
else
  # BEFORE INSTALLATION THIS WILL BE USED
  source "${SRC_NAME}/backup.sh"
  source "${SRC_NAME}/end.sh"
  source "${SRC_NAME}/init.sh"
  source "${SRC_NAME}/override.sh"
  source "${SRC_NAME}/wipe.sh"
  source "${SRC_NAME}/${LIB_NAME}/checkers.sh"
  source "${SRC_NAME}/${LIB_NAME}/etc.sh"
  source "${SRC_NAME}/${LIB_NAME}/getters.sh"
  source "${SRC_NAME}/${LIB_NAME}/loggers.sh"
  source "${SRC_NAME}/${LIB_NAME}/prompters.sh"
  source "${SRC_NAME}/${LIB_NAME}/setters.sh"
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

# This formulation is not necessary but good for debugging
backup $@
