#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 3 2019
# ---------------------------------------- #

LOG_PATH='.'
LOG_DIRECTORY_NAME='backup.logs'
LOG_FILENAME="$(date -u '+%Y-%m-%dT%H:%M:%SZ.log')"

LOG_DIRECTORY=$(get_realpath "$LOG_PATH/$LOG_DIRECTORY_NAME")
LOG_FILE="$LOG_DIRECTORY/$LOG_FILENAME"

## ---- LOGS ---- ##
## These should be done with a parent class (unsupported)

# Uses global options and log
new_subdirectory_log () {
  # PARSING
  local backup=$1
  # FUNCTIONALITY
  local highlight="\t MAKING SUBDIRECTORY IN BACKUP: "
  local log=" $backup "
  test ! $QUIET && echo -e "$(tput setaf 3)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}

# Uses global options and log
backup_log () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2
  # FUNCTIONALITY
  local highlight=" BACKING-UP: "
  local log=" $SOURCE_DIR -> $BACKUP_DIR "
  test ! $QUIET && echo -e "$(tput setaf 6)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}

# Uses global options and log
file_log () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  local highlight="\t CREATING FILE BACKUP: "
  local log=" $source -> $backup "
  test ! $QUIET && echo -e "$(tput setaf 2)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}

# Uses global options and log
override_log () {
  # PARSING
  local backup=$1
  # FUNCTIONALITY
  local highlight=" OVERRIDING: "
  local log=" $backup "
  test ! $QUIET && echo -e "$(tput setaf 6)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}

# Uses global options and log
wipe_log () {
  # FUNCTIONALITY
  local log=" WIPING OUT BACKUP "
  test ! $QUIET && echo -e "$(tput setaf 6)$log$(tput sgr 0)"
  test ! $NO_LOG && echo -e $log >> $LOG_FILE
}

# Uses global options and log
warning_log () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local highlight=" WARNING "
  echo -e "$(tput setab 1)$(tput setaf 7)$highlight$(tput sgr 0)"\
  "$message" >&2
  test ! $NO_LOG && echo -e "$highlight$message" >> $LOG_FILE
}

# Uses global options and log
error_log () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local highlight=" ERROR "
  echo -e "$(tput setab 1)$(tput setaf 7)$highlight$(tput sgr 0)"\
  "$(tput setaf 1)$message$(tput sgr 0)" >&2
  test ! $NO_LOG && echo -e "$highlight$message" >> $LOG_FILE
}
