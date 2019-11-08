#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

get_sorted_tree () {
  # PARSING
  local BASE_DIR=$1
  # FUNCTIONALITY
  IFS=$'\n'
  find "${BASE_DIR}" -not -path '*/\.*' | sed "s,\*,\\\\\\\*,g" | sort
}


get_array_size () {
  #TODO
  :
}


get_realpath() {
  local path=$(echo $1 | sed "s,/*$,,")
  [[ "$path" = /* ]] && echo "$path" || echo "$PWD/${path#./}"
}


get_relative_path () {
  # PARSING
  local path=$1
  local BASE_DIR=$2
  # FUNCTIONALITY
  echo ${path} | sed -e "s,^${BASE_DIR},," -e "s,^\/*,,"
}

# Uses checker and getter
get_backup_path () {
  # PARSING
  local source=$1
  local SOURCE_DIR=$2
  local BACKUP_DIR=$3
  # FUNCTIONALITY
  if is_in_directory "$source" "$SOURCE_DIR"; then
    echo -e "${BACKUP_DIR}/$(get_relative_path "$source" "$SOURCE_DIR")"
  else
    return 1
  fi
}
