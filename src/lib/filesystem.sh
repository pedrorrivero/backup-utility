#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 3 2019
# ---------------------------------------- #

get_sorted_tree () {
  # PARSING
  local BASE_DIR=$1
  # FUNCTIONALITY
  find ${BASE_DIR} | sort
}


is_new_file () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  if [ ! -d $source ] && [ -d $backup ]; then
    error_log "CONFLICT: non-directory \"$source\" -> directory \"$backup\"."
  elif [ ! -d $source ] && [ ! $backup -nt $source ]; then
    return 0  #TRUE
  else
    return 1  #FALSE
  fi
}


is_new_subdirectory () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  if [ -d $source ] && [ ! -e $backup ]; then
    return 0  #TRUE
  elif [ -d $source ] && [ ! -d $backup ]; then
    error_log "CONFLICT: directory \"$source\" -> non-directory \"$backup\"."
  else
    return 1  #FALSE
  fi
}


is_in_directory () {
  # PARSING
  local target=$1
  local TARGET_DIR=$2
  # FUNCTIONALITY
  if [ -e $target ] && [[ $target == ${TARGET_DIR}'/'* ]]
  then
    return 0  #TRUE
  else
    return 1  #FALSE
  fi
}


get_relative_path () {
  # PARSING
  local path=$1
  local BASE_DIR=$2
  # FUNCTIONALITY
  echo ${path} | sed -e "s,^${BASE_DIR},," -e "s,^\/,,"
}


get_backup_path () {
  # PARSING
  local source=$1
  local SOURCE_DIR=$2
  local BACKUP_DIR=$3
  # FUNCTIONALITY
  if is_in_directory $source $SOURCE_DIR
  then
    echo -e "${BACKUP_DIR}/$(get_relative_path $source $SOURCE_DIR)"
  else
    return 1
  fi
}


get_realpath() {
  local path=$(echo $1 | sed "s,/*$,,")
  [[ $path = /* ]] && echo "$path" || echo "$PWD/${path#./}"
}
