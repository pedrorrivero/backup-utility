#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

BIN_NAME='prr-backup'
DIR_NAME='bin'
INSTALLATION_LOCATION='/usr/local/bin'

BIN_PATH="${INSTALLATION_LOCATION}/${BIN_NAME}"
DIR_PATH="${INSTALLATION_LOCATION}/${BIN_NAME}-${DIR_NAME}"

# AFTER/BEFORE INSTALLATION
if [ ! -e $DIR_PATH ]; then
  DIR_PATH='.'
fi


## ---- PRECONFIGURED BACKUP DIRECTORIES ---- ##

# THIS INIZIALIZATION CAN BE SET FOR AUTOMATED BACKUPS
DIRECTORY_PAIRS=$(cat "${DIR_PATH}/preconfig-dirs" 2>/dev/null)


## ---- LIBRARIES ---- ##

source "${DIR_PATH}/lib/backup.sh"
source "${DIR_PATH}/lib/end.sh"
source "${DIR_PATH}/lib/init.sh"
source "${DIR_PATH}/lib/override.sh"
source "${DIR_PATH}/lib/wipe.sh"
source "${DIR_PATH}/src/checkers.sh"
source "${DIR_PATH}/src/etc.sh"
source "${DIR_PATH}/src/getters.sh"
source "${DIR_PATH}/src/loggers.sh"
source "${DIR_PATH}/src/prompters.sh"
source "${DIR_PATH}/src/setters.sh"


## ---- MAIN  ---- ##

backup () {

  local ARGS=$@

  init_backup_mode $ARGS

  for (( i=0; i<${#DIRECTORY_PAIRS[@]}; i+=2 ));
  do

    local SOURCE_DIR=${DIRECTORY_PAIRS[$i]}
    local BACKUP_DIR=${DIRECTORY_PAIRS[$i+1]}

    override_requested_subdirecrories "$SOURCE_DIR" "$BACKUP_DIR"
    wipe_backup_if_requested "$BACKUP_DIR"

    do_backup "$SOURCE_DIR" "$BACKUP_DIR"
  done

  end_backup_mode

}


## ---- EXECUTION ---- ##

# This formulation is not necessary but good for debugging
backup $@
