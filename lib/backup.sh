#!/usr/local/bin/bash

#    _____  _____
#   |  __ \|  __ \    AUTHOR: Pedro Rivero
#   | |__) | |__) |   ---------------------------------
#   |  ___/|  _  /    DATE: November 13, 2019
#   | |    | | \ \    ---------------------------------
#   |_|    |_|  \_\   https://github.com/pedrorrivero
#

# ---------------------------------------- #
#                  MODULE                  #
# ---------------------------------------- #

## ---- DO BACKUP ---- ##
# DEPENDENCIES: getters, loggers, Backup

do_backup () {
  # PARSING
  local SOURCE_DIR="$1"
  local BACKUP_DIR="$2"

  # FUNCTIONALITY
  backup_log "$SOURCE_DIR" "$BACKUP_DIR"

  IFS=$'\n'
  local source_tree=($(get_sorted_tree "${SOURCE_DIR}"))
  local backup=""

  for source in "${source_tree[@]:1}"; do
    backup="$(get_backup_path "$source" "$SOURCE_DIR" "$BACKUP_DIR")"
    if [ -n "$backup" ]; then
      backup_if_new "$source" "$backup"
    fi
    backup=""
  done

  unset IFS
}


## ---- BACKUP IF NEW ---- ##
# DEPENDENCIES: checkers, Backup

backup_if_new () {
  # PARSING
  local source="$1"
  local backup="$2"
  # FUNCTIONALITY
  # This is not CLEAN and could be improved using inheritance
  if is_new_subdirectory "$source" "$backup"; then
    backup_subdirectory "$source" "$backup"
  elif is_new_file "$source" "$backup"; then
    backup_file "$source" "$backup"
  fi
}


## ---- BACKUP SUBDIRECTORY ---- ##
# DEPENDENCIES: GLOBAL, checkers, getters, loggers

backup_subdirectory () {
  # PARSING
  local source="$1"
  local backup="$2"
  # FUNCTIONALITY
  local stderr=''
  new_subdirectory_log "$backup"
  if [ -z "$DRY_RUN" ]; then
    stderr="$(mkdir "$backup" 2>&1)"
    test -n "$stderr" && warning_log "$stderr"
  fi
}


## ---- BACKUP FILE ---- ##
# DEPENDENCIES: GLOBAL, checkers, getters, loggers

backup_file () {
  # PARSING
  local source="$1"
  local backup="$2"
  # FUNCTIONALITY
  local stderr=''
  file_log "$source" "$backup"
  if [ -z "$DRY_RUN" ]; then
    stderr="$(cp -f "$source" "$backup" 2>&1)"
    test -n "$stderr" && warning_log "$stderr"
  fi
}
