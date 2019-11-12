#!/usr/local/bin/bash

#    _____  _____
#   |  __ \|  __ \    AUTHOR: Pedro Rivero
#   | |__) | |__) |   ---------------------------------
#   |  ___/|  _  /    DATE: November 12, 2019
#   | |    | | \ \    ---------------------------------
#   |_|    |_|  \_\   https://github.com/pedrorrivero
#

# ---------------------------------------- #
#                FUNCTIONS                 #
# ---------------------------------------- #

## ---- RESET OPTIONS ---- ##
# DEPENDENCIES: GLOBAL

reset_options () {
  unset OVERRIDE

  QUIET=''
  DRY_RUN=''
  LOG='set'
  WIPE=''
  FORCE=''
  HIDDEN=''
}


## ---- SET GLOBAL TO ARRAY ---- ##
# DEPENDENCIES: GLOBAL

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
