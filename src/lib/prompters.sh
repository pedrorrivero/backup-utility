#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

# Uses global options and prompter
ask_confirmation () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local confirmation=''
  if [ -z $FORCE ]
  then
    while ! confirm_answer $confirmation
    do
      read -p " $1 [y/n]: " confirmation
    done
  fi
}

# Uses etc
confirm_answer () {
  # PARSING
  local confirmation=$1
  # FUNCTIONALITY
  if [[ $confirmation == 'n' ]] || [[ $confirmation == 'N' ]]
  then
    echo "Backup cancelled..."
    custom_exit 0
  elif [[ $confirmation == 'y' ]] || [[ $confirmation == 'Y' ]]
  then
    return 0  #TRUE
  else
    return 1  #FALSE
  fi
}