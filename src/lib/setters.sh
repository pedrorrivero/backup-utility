#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

# Uses global options
reset_options () {
  OVERRIDE=""

  QUIET=''
  DRY_RUN=''
  LOG='set'
  WIPE=''
  FORCE=''
}

# Uses generic global
set_global_to_array () {
  # PARSING
  local global_name=$1
  # FUNCTIONALITY
  local OLD_IFS=$IFS
  IFS=' ' read -ra "$global_name" <<< $(eval echo '${'$global_name'[@]}')
  IFS=$OLD_IFS
}
