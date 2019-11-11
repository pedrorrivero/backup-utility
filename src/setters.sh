#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

# Uses global options
reset_options () {
  unset OVERRIDE

  QUIET=''
  DRY_RUN=''
  LOG='set'
  WIPE=''
  FORCE=''
  HIDDEN=''
}

# Uses generic global
set_global_to_array () {
  # PARSING
  local global_name="$1"
  # FUNCTIONALITY
  IFS=$'\n'
  local i=0
  for line in $(eval echo '"${'$global_name'}"'); do
    eval $global_name'['$i']'='"'$line'"'
    ((i++))
  done
  unset IFS
}
