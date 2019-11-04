#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 3 2019
# ---------------------------------------- #

get_sorted_tree () {
  # PARSING
  local BASE_DIR=$(fix_dir_path $1)
  # FUNCTIONALITY
  find ${BASE_DIR} | sort
}


fix_dir_path () {
  # PARSING
  local dir_path=$1
  # FUNCTIONALITY
  local fixed_path=$(echo $dir_path | sed "s,/*$,,")
  echo $fixed_path
}


get_relative_path () {
  # PARSING
  local path=$1
  local BASE_DIR=$(fix_dir_path $2)
  # FUNCTIONALITY
  echo ${path} | sed -e "s,^${BASE_DIR},," -e "s,^\/,,"
}


is_in_directory () {
  # PARSING
  local target=$1
  local TARGET_DIR=$(fix_dir_path $2)
  # FUNCTIONALITY
  if [[ $target == ${TARGET_DIR}'/'* ]]; then
    return 0
  fi
}


get_backup_path () {
  # PARSING
  local source=$1
  local SOURCE_DIR=$(fix_dir_path $2)
  local BACKUP_DIR=$(fix_dir_path $3)
  # FUNCTIONALITY
  if is_in_directory $source $SOURCE_DIR
  then
    echo -e "${BACKUP_DIR}/$(get_relative_path $source $SOURCE_DIR)"
  else
    return 1
  fi
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


realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}
