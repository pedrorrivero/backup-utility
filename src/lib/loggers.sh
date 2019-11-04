#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- LOG FILES ---- ##

if [ -e '/usr/local/bin/prr-backup-src' ]; then
  # AFTER INSTALLATION THIS WILL BE USED
  LOG_PATH='/usr/local/bin/prr-backup-src/..'
else
  # BEFORE INSTALLATION THIS WILL BE USED
  LOG_PATH='.'
fi

LOG_DIRECTORY_NAME='backup.logs'
LOG_FILENAME="$(date -u '+%Y-%m-%dT%H:%M:%SZ.log')"

LOG_DIRECTORY=$(get_realpath "$LOG_PATH/$LOG_DIRECTORY_NAME")
LOG_FILE="$LOG_DIRECTORY/$LOG_FILENAME"

## ---- LOG FUNCTIONS ---- ##

# Uses global options and log
new_subdirectory_log () {
  # PARSING
  local subdirectory=$1

  # FUNCTIONALITY
  local highlight="\t MAKING SUBDIRECTORY IN BACKUP: "
  local log=" $subdirectory "

  if [ -z $QUIET ]; then
    echo -e "$(tput setaf 3)$highlight$(tput sgr 0)$log"
  fi
  if [ ! -z $LOG ]; then
    echo -e "$highlight$log" >> $LOG_FILE
  fi
}

# Uses global options and log
backup_log () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2

  # FUNCTIONALITY
  local highlight=" BACKING-UP: "
  local log=" $SOURCE_DIR -> $BACKUP_DIR "

  if [ -z $QUIET ]; then
    echo -e "$(tput setaf 6)$highlight$(tput sgr 0)$log"
  fi
  if [ ! -z $LOG ]; then
    echo -e "$highlight$log" >> $LOG_FILE
  fi
}

# Uses global options and log
file_log () {
  # PARSING
  local source=$1
  local backup=$2

  # FUNCTIONALITY
  local highlight="\t CREATING FILE BACKUP: "
  local log=" $source -> $backup "

  if [ -z $QUIET ]; then
    echo -e "$(tput setaf 2)$highlight$(tput sgr 0)$log"
  fi
  if [ ! -z $LOG ]; then
    echo -e "$highlight$log" >> $LOG_FILE
  fi
}

# Uses global options and log
override_log () {
  # PARSING
  local backup=$1

  # FUNCTIONALITY
  local highlight=" OVERRIDING: "
  local log=" $backup "

  if [ -z $QUIET ]; then
    echo -e "$(tput setaf 6)$highlight$(tput sgr 0)$log"
  fi
  if [ ! -z $LOG ]; then
    echo -e "$highlight$log" >> $LOG_FILE
  fi
}

# Uses global options and log
wipe_log () {
  # FUNCTIONALITY
  local log=" WIPING OUT BACKUP "

  if [ -z $QUIET ]; then
    echo -e "$(tput setaf 6)$log$(tput sgr 0)"
  fi
  if [ ! -z $LOG ]; then
    echo -e $log >> $LOG_FILE
  fi
}

# Uses global options and log
warning_log () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local highlight=" WARNING "
  echo -e "$(tput setab 1)$(tput setaf 7)$highlight$(tput sgr 0)"\
  "$message" >&2
  if [ ! -z $LOG ]; then
    echo -e "$highlight$message" >> $LOG_FILE
  fi
}

# Uses global options and log
error_log () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local highlight=" ERROR "
  echo -e "$(tput setab 1)$(tput setaf 7)$highlight$(tput sgr 0)"\
  "$(tput setaf 1)$message$(tput sgr 0)" >&2
  if [ ! -z $LOG ]; then
    echo -e "$highlight$message" >> $LOG_FILE
  fi
  custom_exit 1
}
