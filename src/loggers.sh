#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- LOG FILES ---- ##

if [ -e '/usr/local/bin/prr-backup-bin' ]; then
  # AFTER INSTALLATION THIS WILL BE USED
  LOG_PATH='/usr/local/bin/prr-backup-bin/'
else
  # BEFORE INSTALLATION THIS WILL BE USED
  LOG_PATH='.'
fi

LOG_DIRECTORY_NAME='logs'
LOG_FILENAME="$(date -u '+%Y-%m-%dT%H:%M:%SZ.log')"

LOG_DIRECTORY=$(get_realpath "$LOG_PATH/$LOG_DIRECTORY_NAME")
LOG_FILE="$LOG_DIRECTORY/$LOG_FILENAME"


## ---- LOG FUNCTIONS ---- ##

# Uses log
new_subdirectory_log () {
  # PARSING
  local subdirectory=$1

  # FUNCTIONALITY
  local color='3'
  local highlight="\t MAKING SUBDIRECTORY IN BACKUP: "
  local log=" $subdirectory "

  stdout_log_echo "$color" "$highlight" "$log"
}

# Uses log
backup_log () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2

  # FUNCTIONALITY
  local color='6'
  local highlight="\n$(tput rev) BACKING-UP: "
  local log=" $SOURCE_DIR $(tput setaf $color)->$(tput sgr 0) $BACKUP_DIR "

  backup_log_echo "$color" "$highlight" "$log"
}

# Uses log
file_log () {
  # PARSING
  local source=$1
  local backup=$2

  # FUNCTIONALITY
  local color='2'
  local highlight="\t CREATING FILE BACKUP: "
  local log=" $source $(tput setaf $color)->$(tput sgr 0) $backup "

  stdout_log_echo "$color" "$highlight" "$log"
}

# Uses log
override_log () {
  # PARSING
  local backup=$1

  # FUNCTIONALITY
  local color='6'
  local highlight="\n OVERRIDING: "
  local log=" $backup "

  stdout_log_echo "$color" "$highlight" "$log"
}

# Uses log
wipe_log () {
  # PARSING
  local BACKUP_DIR=$1
  # FUNCTIONALITY
  local color='6'
  local highlight="\n WIPING OUT BACKUP: "
  local log=" $BACKUP_DIR "

  stdout_log_echo "$color" "$highlight" "$log"
}

# Uses log
warning_log () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local color='3'
  local highlight=" WARNING "

  stderr_log_echo "$color" "$highlight" "$message"
}

# Uses log
error_log () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local color='1'
  local highlight=" ERROR "

  stderr_log_echo "$color" "$highlight" "$message"
}


## ---- LOG ECHOS ---- ##

# Uses global options and log
backup_log_echo () {
  # PARSING
  local color=$1
  local highlight=$2
  local log=$3
  # FUNCTIONALITY
  echo -e "$(tput setaf $color)$highlight$(tput sgr 0)$log"
  if [ ! -z "$LOG" ]; then
    echo -e "$highlight$log" >> $LOG_FILE
  fi
}

# Uses global options and log
stdout_log_echo () {
  # PARSING
  local color=$1
  local highlight=$2
  local log=$3
  # FUNCTIONALITY
  if [ -z "$QUIET" ]; then
    echo -e "$(tput setaf $color)$highlight$(tput sgr 0)$log"
  fi
  if [ ! -z "$LOG" ]; then
    echo -e "$highlight$log" >> $LOG_FILE
  fi
}

# Uses global options and log
stderr_log_echo () {
  # PARSING
  local color=$1
  local highlight=$2
  local log=$3
  # FUNCTIONALITY
  echo -e "$(tput setab 1)$(tput setaf 7)$highlight$(tput sgr 0)"\
  "$(tput setaf $color)$message$(tput sgr 0)" >&2
  if [ ! -z "$LOG" ]; then
    echo -e "$highlight$message" >> $LOG_FILE
  fi
}
