#!/usr/local/bin/bash

SOURCE_DIR='./test'
BACKUP_DIR='./test.backup'

LOG_FILE=$(date -u '+%Y-%m-%dT%H:%M:%SZ.log')


## ---- OPTION FLAGS ---- ##

PARAMS=""
OVERRIDE=""

VERBOSE=''
DRY_RUN=''
NO_LOG=''
WIPE=''


## ---- PARSER ---- ##

option_parser () {

  while (( "$#" )); do
  case "$1" in
    -v|--verbose)
      VERBOSE='set'
      tabs 4
      shift
      ;;
    -d|--dry-run)
      DRY_RUN='set'
      VERBOSE='set'
      shift
      ;;
    -n|--no-log)
      NO_LOG='set'
      shift
      ;;
    -o|--override)
      OVERRIDE="$OVERRIDE $2"
      shift 2
      ;;
    -w|--wipe-backup)
      WIPE='set'
      shift 2
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      local log=" Error: Unsupported flag $1 "
      echo "$(tput setaf 1)$log$(tput sgr 0)" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done

global_to_array "OVERRIDE"
# eval set -- "$PARAMS"

}


## ---- LOGS ---- ##


subdirectory_log () {
  # PARSING
  local backup=$1
  # FUNCTIONALITY
  local highlight="\t MAKING SUBDIRECTORY IN BACKUP: "
  local log=" $backup "
  test $VERBOSE && echo -e "$(tput setaf 3)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}


backup_log () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2
  # FUNCTIONALITY
  local highlight=" BACKING-UP: "
  local log=" $SOURCE_DIR -> $BACKUP_DIR "
  test $VERBOSE && echo -e "$(tput setaf 6)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}


file_log () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  local highlight="\t CREATING FILE BACKUP: "
  local log=" $source -> $backup "
  test $VERBOSE && echo -e "$(tput setaf 2)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}


override_log () {
  # PARSING
  local backup=$1
  # FUNCTIONALITY
  local highlight=" OVERRIDING: "
  local log=" $backup "
  test $VERBOSE && echo -e "$(tput setaf 6)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}


wipe_log () {
  # FUNCTIONALITY
  local log=" WIPING OUT BACKUP "
  test $VERBOSE && echo -e "$(tput setaf 6)$log$(tput sgr 0)"
  test ! $NO_LOG && echo -e $log >> $LOG_FILE
}


warning_log () {
  # PARSING
  local warning=$1
  # FUNCTIONALITY
  local highlight=" WARNING: "
  local log=" Could not deal with \"$warning\" "
  echo -e "$(tput setab 1)$(tput setaf 7)$highlight$(tput sgr 0)$log" >&2
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}


## ---- FUNCTIONS ---- ##


global_to_array () {
  # PARSING
  local global_name=$1
  # FUNCTIONALITY
  IFS=' ' read -ra $global_name <<< $(eval echo '$'$global_name)
}


get_sorted_tree () {
  # PARSING
  local BASE_DIR=$1
  # FUNCTIONALITY
  find ${BASE_DIR} | sort
}


get_relative_path () {
  # PARSING
  local source=$1
  local BASE_DIR=$2
  # FUNCTIONALITY
  echo ${source} | sed -e "s,^${BASE_DIR},," -e "s,^\/,,"
}


override () {
  local target=''
  for subdirectory in "${OVERRIDE[@]}"
  do
    target="${BACKUP_DIR}/$(get_relative_path $subdirectory $SOURCE_DIR)"
    if [ -d $target ]
    then
      override_log $target
      rm -rf $target
    else
      warning_log $subdirectory
    fi
  done
}


is_new_subdirectory () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  test -d $source && test ! -d $backup
}


is_new_file () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  test ! -d $source && test ! $backup -nt $source
}


backup_if_new () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  if is_new_subdirectory $source $backup
  then
    subdirectory_log $backup
    test ! $DRY_RUN && mkdir $backup
  elif is_new_file $source $backup
  then
    file_log $source $backup
    test ! $DRY_RUN && cp $source $backup
  fi
}


update_backup_directory () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2

  # FUNCTIONALITY
  backup_log $SOURCE_DIR $BACKUP_DIR
  local source_tree=($(get_sorted_tree ${SOURCE_DIR}))

  for source in "${source_tree[@]:1}"
  do
    local backup="${BACKUP_DIR}/$(get_relative_path $source $SOURCE_DIR)"
    backup_if_new $source $backup
  done
}


## ---- CODE TO EXECUTE ---- ##

option_parser $@
test ! $NO_LOG && touch $LOG_FILE 2> /dev/null
override
update_backup_directory $SOURCE_DIR $BACKUP_DIR
