#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

get_encoded_tree () {
  # PARSING
  local BASE_DIR="$1"
  # FUNCTIONALITY
  IFS=$'\n'
  if [ ! -z "$HIDDEN" ]; then
    local tree=$(find "${BASE_DIR}")
  else
    local tree=$(find "${BASE_DIR}" -not -path '*/\.*')
  fi
  # '*' gets substituted by '\\*'
  # ' ' gets substituted by '\\'

  # echo "$tree"

  local encoded_tree=''
  for source in "${tree[@]}"; do
    encoded_tree+=$(get_encoded_path "$source")
    encoded_tree+=' '
  done
  IFS=' '
  echo "$encoded_tree" | sort
  IFS=$'\n'
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
  local BASE_DIR="$2"
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

get_encoded_path () {
  # PARSING
  local path=''
  if [ -z "$1" ]; then
    read path
  else
    path="$@"
  fi
  # FUNCTIONALITY

  echo "$path" | awk '{ gsub(" ","\\\\"); gsub("\\*","\\\\*"); print }'
}

get_decoded_path () {
  # PARSING
  local path=''
  if [ -z "$1" ]; then
    read path
  else
    path="$@"
  fi
  # FUNCTIONALITY
  echo "$path" | awk '{ gsub("\\\\\\\\\\*","*"); gsub("\\\\\\\\"," "); print }'
}
