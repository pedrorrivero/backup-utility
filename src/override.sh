#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

# Uses global options
override_requested_subdirecrories () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2
  # FUNCTIONALITY
  local target=''
  for subdirectory in "${OVERRIDE[@]}"
  do
    target=$(get_backup_path $subdirectory $SOURCE_DIR $BACKUP_DIR)
    if [ -z $target ]; then
      :
    elif [ -e $target ]; then
      override_log $target
      override_if_wet $target
    else
      warning_log "NOTHING TO OVERRIDE: \"$target\" does not exist."
    fi
  done
}


# Uses global options
override_if_wet () {
  # PARSING
  local target=$1
  # FUNCTIONALITY
  if [ -z $DRY_RUN ]
  then
    ask_confirmation "Confirm override subdirectory \"$target\""
    rm -rf $target
  fi
}
