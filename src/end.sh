#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

# Uses global options and log
end_backup_mode () {
  if [ ! -z $LOG ]
  then
    echo -e "\n$(tput setab 0)$(tput setaf 7) Logs saved to: $(tput sgr 0) $LOG_FILE \n"
  else
    echo -en "\n"
  fi
}
