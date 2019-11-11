#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

get_sorted_tree () {
  # PARSING
  local BASE_DIR="$1"
  # FUNCTIONALITY
  if [ ! -z "$HIDDEN" ]; then
    local tree=$(find "${BASE_DIR}")
  else
    local tree=$(find "${BASE_DIR}" -not -path '*/\.*')
  fi
  echo "$tree"
}


get_array_size () {
  #TODO
  :
}


get_realpath() {
  local path="$(echo "$1" | awk '{ gsub("/*$",""); print }')"
  [[ "$path" = /* ]] && echo "$path" || echo "$PWD/${path#./}"
}


get_relative_path () {
  # PARSING
  local path="$1"
  local BASE_DIR="$(get_escaped_string "$2")"
  # FUNCTIONALITY
  echo "${path}" | awk '{ gsub("^'"${BASE_DIR}"'",""); gsub("^\/*",""); print }'
}

# Uses checker and getter
get_backup_path () {
  # PARSING
  local source="$1"
  local SOURCE_DIR="$2"
  local BACKUP_DIR="$3"
  # FUNCTIONALITY
  if is_in_directory "$source" "$SOURCE_DIR"; then
    echo "${BACKUP_DIR}/$(get_relative_path "$source" "$SOURCE_DIR")"
  else
    return 1
  fi
}

get_escaped_string () {
  # PARSING
  local string=''
  if [ -z "$1" ]; then
    read string
  else
    string="$@"
  fi
  # FUNCTIONALITY
  echo "$string" | awk '{ gsub("[*?+{}|()]","\\\\\\\\&"); print }'
}
