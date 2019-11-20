#!/usr/local/bin/bash

#    _____  _____
#   |  __ \|  __ \    AUTHOR: Pedro Rivero
#   | |__) | |__) |   ---------------------------------
#   |  ___/|  _  /    DATE: November 13, 2019
#   | |    | | \ \    ---------------------------------
#   |_|    |_|  \_\   https://github.com/pedrorrivero
#

# ---------------------------------------- #
#                LOG FILES                 #
# ---------------------------------------- #

if [ -e '/usr/local/bin/prr-backup-bin' ]; then
  # AFTER INSTALLATION THIS WILL BE USED
  LOG_PATH='/usr/local/bin/prr-backup-bin'
else
  # BEFORE INSTALLATION THIS WILL BE USED
  LOG_PATH='.'
fi

LOG_DIRECTORY_NAME='logs'
LOG_FILENAME="$(date -u '+%Y-%m-%dT%H:%M:%S.000Z.log')"

LOG_DIRECTORY=$(get_realpath "$LOG_PATH/$LOG_DIRECTORY_NAME")
LOG_FILE="$LOG_DIRECTORY/$LOG_FILENAME"


# ---------------------------------------- #
#              LOG FUNCTIONS               #
# ---------------------------------------- #

## ---- LOG BACKUP BRIEFING ---- ##
# DEPENDENCIES: GLOBAL

briefing_log () {
  local color='4'
  local highlight="\n$(tput setab 7)$(tput rev)BACKUP BRIEFING"
  local log=""

  backup_log_echo "$color" "$highlight" "$log"

  # Reset
  highlight=""
  log=""

  # Loop through all requested backups
  IFS=$'\n'
  local number_of_directories="${#DIRECTORY_PAIRS[@]}"

  for (( i = 0; i < $number_of_directories; i+=2 )); do
    log="    ${DIRECTORY_PAIRS[$i]} $(tput setaf "$color")->$(tput sgr 0) ${DIRECTORY_PAIRS[$i+1]}"
    backup_log_echo "$color" "$highlight" "$log"
  done

  unset IFS
}


## ---- NEW SUBDIRECTORY LOG ---- ##
# DEPENDENCIES: loggers

new_subdirectory_log () {
  # PARSING
  local subdirectory="$1"

  # FUNCTIONALITY
  local color='3'
  local highlight="\t MAKING SUBDIRECTORY IN BACKUP: "
  local log=" $subdirectory "

  stdout_log_echo "$color" "$highlight" "$log"
}


## ---- BACKUP LOG ---- ##
# DEPENDENCIES: loggers

backup_log () {
  # PARSING
  local SOURCE_DIR="$1"
  local BACKUP_DIR="$2"

  # FUNCTIONALITY
  local color='6'
  local highlight="\n$(tput rev) BACKING-UP: "
  local log=" $SOURCE_DIR $(tput setaf $color)->$(tput sgr 0) $BACKUP_DIR "

  backup_log_echo "$color" "$highlight" "$log"
}


## ---- FILE LOG ---- ##
# DEPENDENCIES: loggers

file_log () {
  # PARSING
  local source="$1"
  local backup="$2"

  # FUNCTIONALITY
  local color='2'
  local highlight="\t CREATING FILE BACKUP: "
  local log=" $source $(tput setaf $color)->$(tput sgr 0) $backup "

  stdout_log_echo "$color" "$highlight" "$log"
}


## ---- OVERRIDE LOG ---- ##
# DEPENDENCIES: loggers

override_log () {
  # PARSING
  local backup="$1"

  # FUNCTIONALITY
  local color='6'
  local highlight="\n OVERRIDING: "
  local log=" $backup "

  stdout_log_echo "$color" "$highlight" "$log"
}


## ---- WIPE LOG ---- ##
# DEPENDENCIES: loggers

wipe_log () {
  # PARSING
  local BACKUP_DIR="$1"
  # FUNCTIONALITY
  local color='6'
  local highlight="\n WIPING OUT BACKUP: "
  local log=" $BACKUP_DIR "

  stdout_log_echo "$color" "$highlight" "$log"
}


## ---- WARNING LOG ---- ##
# DEPENDENCIES: loggers

warning_log () {
  # PARSING
  local message="$1"
  # FUNCTIONALITY
  local color='3'
  local highlight=" WARNING "

  stderr_log_echo "$color" "$highlight" "$message"
}


## ---- ERROR LOG ---- ##
# DEPENDENCIES: loggers

error_log () {
  # PARSING
  local message="$1"
  # FUNCTIONALITY
  local color='1'
  local highlight=" ERROR "

  stderr_log_echo "$color" "$highlight" "$message"
}


# ---------------------------------------- #
#                LOG ECHOS                 #
# ---------------------------------------- #

## ---- BACKUP LOG ECHO ---- ##
# DEPENDENCIES: GLOBAL

backup_log_echo () {
  # PARSING
  local color="$1"
  local highlight="$2"
  local log="$3"
  # FUNCTIONALITY
  echo -e "$(tput setaf $color)$highlight$(tput sgr 0)$log"
  if [ -n "$LOG" ]; then
    echo -e "$highlight$log" >> $LOG_FILE
  fi
}


## ---- STDOUT LOG ECHO ---- ##
# DEPENDENCIES: GLOBAL

stdout_log_echo () {
  # PARSING
  local color="$1"
  local highlight="$2"
  local log="$3"
  # FUNCTIONALITY
  if [ -z "$QUIET" ]; then
    echo -e "$(tput setaf $color)$highlight$(tput sgr 0)$log"
  fi
  if [ -n "$LOG" ]; then
    echo -e "$highlight$log" >> $LOG_FILE
  fi
}


## ---- STDERR LOG ECHO ---- ##
# DEPENDENCIES: GLOBAL

stderr_log_echo () {
  # PARSING
  local color="$1"
  local highlight="$2"
  local log="$3"
  # FUNCTIONALITY
  echo -e "$(tput setab 1)$(tput setaf 7)$highlight$(tput sgr 0)"\
  "$(tput setaf $color)$message$(tput sgr 0)" >&2
  if [ -n "$LOG" ]; then
    echo -e "$highlight$message" >> $LOG_FILE
  fi
}
