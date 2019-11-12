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

## ---- ASK CONFIRMATION ---- ##
# DEPENDENCIES: GLOBAL, prompters

ask_confirmation () {
  # PARSING
  local message="$1"
  # FUNCTIONALITY
  local confirmation=''
  if [ -z "$FORCE" ]; then
    while ! confirm_answer "$confirmation"; do
      read -p " $1 [y/n]: " confirmation
    done
  fi
}


## ---- CONFIRM ANSWER ---- ##
# DEPENDENCIES: etc

confirm_answer () {
  # PARSING
  local confirmation="$1"
  # FUNCTIONALITY
  if [[ "$confirmation" == 'n' ]] || [[ "$confirmation" == 'N' ]]; then
    echo "Backup cancelled..."
    custom_exit 0
  elif [[ "$confirmation" == 'y' ]] || [[ "$confirmation" == 'Y' ]]
  then
    return 0  #TRUE
  else
    return 1  #FALSE
  fi
}
