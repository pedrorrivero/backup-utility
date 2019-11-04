#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

# Uses global options
backup_if_new () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  if is_new_subdirectory $source $backup && [ -z $DRY_RUN ]
  then
    new_subdirectory_log $backup
    mkdir $backup
  elif is_new_file $source $backup && [ -z $DRY_RUN ]
  then
    file_log $source $backup
    cp $source $backup
  fi
}

# Uses global options (inherited)
do_backup () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2

  # FUNCTIONALITY
  backup_log $SOURCE_DIR $BACKUP_DIR
  local source_tree=($(get_sorted_tree ${SOURCE_DIR}))
  local backup=""

  for source in "${source_tree[@]:1}"
  do
    backup="${BACKUP_DIR}/$(get_relative_path $source $SOURCE_DIR)"
    backup_if_new $source $backup
  done
}
