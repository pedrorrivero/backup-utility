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
  local highlight="\t MAKING SUBDIRECTORY IN BACKUP: "
  local log=" $subdirectory "
  local color='3'

  stdout_log_echo "$highlight" "$log" "$color"
}

# Uses log
backup_log () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2

  # FUNCTIONALITY
  local highlight=" BACKING-UP: "
  local log=" $SOURCE_DIR -> $BACKUP_DIR "
  local color='6'

  stdout_log_echo "$highlight" "$log" "$color"
}

# Uses log
file_log () {
  # PARSING
  local source=$1
  local backup=$2

  # FUNCTIONALITY
  local highlight="\t CREATING FILE BACKUP: "
  local log=" $source -> $backup "
  local color='2'

  stdout_log_echo "$highlight" "$log" "$color"
}

# Uses log
override_log () {
  # PARSING
  local backup=$1

  # FUNCTIONALITY
  local highlight=" OVERRIDING: "
  local log=" $backup "
  local color='6'

  stdout_log_echo "$highlight" "$log" "$color"
}

# Uses log
wipe_log () {
  # PARSING
  local BACKUP_DIR=$1
  # FUNCTIONALITY
  local highlight=" WIPING OUT BACKUP: "
  local log" $BACKUP_DIR "
  local color='6'

  stdout_log_echo "$highlight" "$log" "$color"
}

# Uses log
warning_log () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local highlight=" WARNING "
  local color='3'

  stdout_log_echo "$highlight" "$message" "$color"
}

# Uses log
error_log () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local highlight=" ERROR "
  local color='1'

  stdout_log_echo "$highlight" "$message" "$color"
}


## ---- LOG ECHOS ---- ##

# Uses global options and log
stdout_log_echo () {
  # PARSING
  local highlight=$1
  local log=$2
  local color=$3
  # FUNCTIONALITY
  if [ -z $QUIET ]; then
    echo -e "$(tput setaf $color)$highlight$(tput sgr 0)$log"
  fi
  if [ ! -z $LOG ]; then
    echo -e "$highlight$log" >> $LOG_FILE
  fi
}

# Uses global options and log
stderr_log_echo () {
  # PARSING
  local highlight=$1
  local message=$2
  local color=$3
  # FUNCTIONALITY
  echo -e "$(tput setab 1)$(tput setaf 7)$highlight$(tput sgr 0)"\
  "$(tput setaf $3)$message$(tput sgr 0)" >&2
  if [ ! -z $LOG ]; then
    echo -e "$highlight$message" >> $LOG_FILE
  fi
}
