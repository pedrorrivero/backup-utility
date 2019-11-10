#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

# Uses global options, loggers and prompters
wipe_backup_if_requested () {
  # PARSING
  local target="$1"
  # FUNCTIONALITY
  if [ ! -z "$WIPE" ] && [ -z "$DRY_RUN" ] && [ ! -z "$target" ]
  then
    wipe_log "$target"
    ask_confirmation "Confirm wipe backup \"$target\""
    rm -rf "$target/"*
    rm -rf "$target/."*
  fi
}
