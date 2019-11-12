#!/usr/local/bin/bash

#    _____  _____
#   |  __ \|  __ \    AUTHOR: Pedro Rivero
#   | |__) | |__) |   ---------------------------------
#   |  ___/|  _  /    DATE: November 12, 2019
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
  # The next command returns an array with all paths encoded:
  # '*' -> '\\*' and ' ' -> '\\'
  IFS=$'\n'
  local source_tree=($(get_sorted_tree "${SOURCE_DIR}"))
  local backup=""

  for source in "${source_tree[@]:1}"; do
    backup="$(get_backup_path "$source" "$SOURCE_DIR" "$BACKUP_DIR")"
    if [ -z "$backup" ]; then
      :
    else
      backup_if_new "$source" "$backup"
    fi
  done
  unset IFS
}


## ---- BACKUP IF NEW ---- ##
# DEPENDENCIES: GLOBAL, checkers, getters, loggers

backup_if_new () {
  # PARSING
  local source="$1"
  local backup="$2"
  # FUNCTIONALITY
  local stderr=''
  if is_new_subdirectory "$source" "$backup"; then
    new_subdirectory_log "$backup"
    if [ -z "$DRY_RUN" ]; then
      stderr="$(mkdir "$backup" 2>&1)"
      if [ ! -z "$stderr" ]; then
        warning_log "$stderr"
      fi
    fi
  elif is_new_file "$source" "$backup"; then
    file_log "$source" "$backup"
    if [ -z "$DRY_RUN" ]; then
      stderr="$(cp -f "$source" "$backup" 2>&1)"
      if [ ! -z "$stderr" ]; then
        warning_log "$stderr"
      fi
    fi
  fi
}