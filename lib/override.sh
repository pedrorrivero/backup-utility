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

## ---- OVERRIDE REQUESTERD SUBDIRECTORIES ---- ##
# DEPENDENCIES: GLOBAL, getters, loggers, Overrride

override_requested_subdirecrories () {
  # PARSING
  local SOURCE_DIR="$1"
  local BACKUP_DIR="$2"
  # FUNCTIONALITY
  local target=''
  for subdirectory in "${OVERRIDE[@]}"; do
    target="$(get_backup_path "$subdirectory" "$SOURCE_DIR" "$BACKUP_DIR")"
    if [ -z "$target" ]; then
      :
    elif [ -e "$target" ]; then
      override_log "$target"
      override_if_wet "$target"
    else
      warning_log "NOTHING TO OVERRIDE: \"$target\" does not exist."
    fi
  done
  echo -en "\n"
}


## ---- OVERRIDE IF WET ---- ##
# DEPENDENCIES: GLOABL, prompters

override_if_wet () {
  # PARSING
  local target="$1"
  # FUNCTIONALITY
  if [ -z "$DRY_RUN" ]; then
    ask_confirmation "Confirm override subdirectory \"$target\""
    rm -rf "$target"
  fi
}
