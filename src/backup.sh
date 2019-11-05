#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

# Uses backup, getters and loggers
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
    backup=$(get_backup_path $source $SOURCE_DIR $BACKUP_DIR)
    if [ -z $backup ]; then
      :
    else
      backup_if_new $source $backup
    fi
  done
}

# Uses global options, checkers, getters and loggers
backup_if_new () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  if is_new_subdirectory $source $backup
  then
    new_subdirectory_log $backup
    if [ -z $DRY_RUN ]; then
      mkdir $backup
    fi
  elif is_new_file $source $backup
  then
    file_log $source $backup
    if [ -z $DRY_RUN ]; then
      cp $source $backup
    fi
  fi
}
