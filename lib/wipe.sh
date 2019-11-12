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

## ---- WIPE BACKUP IF REQUESTED ---- ##
# DEPENDENCIES: GLOBAL, loggers, prompters

wipe_backup_if_requested () {
  # PARSING
  local target="$1"
  # FUNCTIONALITY
  if [ ! -z "$WIPE" ] && [ -z "$DRY_RUN" ] && [ ! -z "$target" ]; then
    wipe_log "$target"
    ask_confirmation "Confirm wipe backup \"$target\""
    rm -rf "$target/"* 2> /dev/null
    rm -rf "$target/."* 2> /dev/null
    echo -en "\n"
  fi
}
