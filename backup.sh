#!/usr/local/bin/bash

SOURCE_DIR='./test'
BACKUP_DIR='./test.backup'

LOG_FILE=$(date -u '+%Y-%m-%dT%H:%M:%SZ.log')
touch $LOG_FILE 2> /dev/null


## ---- FUNCTIONS ---- ##

directory_log () {
  # PARSING
  local backup=$1
  # FUNCTIONALITY
  local log="\t MAKING DIRECTORY IN BACKUP:  $backup "
  echo -e "$(tput setaf 3)$log$(tput sgr 0)"
  echo -e $log >> $LOG_FILE
}

warning_log () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  local log="\t FAILIURE WARNING: $source -> $backup "
  echo -e "$(tput setaf 1)$log$(tput sgr 0)"
  echo -e $log >> $LOG_FILE
}

backup_log () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2
  # FUNCTIONALITY
  local log=" BACKING-UP: $SOURCE_DIR -> $BACKUP_DIR "
  echo -e "$(tput setaf 6)$log$(tput sgr 0)"
  echo -e $log >> $LOG_FILE
}

file_log () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  local log="\t CREATING FILE BACKUP: $source -> $backup"
  echo -e "$log"
  echo -e $log >> $LOG_FILE
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

is_new_directory () {
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
  if is_new_directory $source $backup
  then
    directory_log $backup
    mkdir $backup
  elif is_new_file $source $backup
  then
    file_log $source $backup
    cp $source $backup
  else
    warning_log $source $backup
  fi
}

update_backup () {
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

tabs 4
update_backup $SOURCE_DIR $BACKUP_DIR
