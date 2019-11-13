#!/usr/local/bin/bash

#    _____  _____
#   |  __ \|  __ \    AUTHOR: Pedro Rivero
#   | |__) | |__) |   ---------------------------------
#   |  ___/|  _  /    DATE: November 13, 2019
#   | |    | | \ \    ---------------------------------
#   |_|    |_|  \_\   https://github.com/pedrorrivero
#

# ---------------------------------------- #
#                FUNCTIONS                 #
# ---------------------------------------- #

## ---- GET SORTED TREE ---- ##
# DEPENDENCIES:

get_sorted_tree () {
  # PARSING
  local BASE_DIR="$1"
  # FUNCTIONALITY
  if [ -n "$HIDDEN" ]; then
    local tree=$(find "${BASE_DIR}" | sort)
  else
    local tree=$(find "${BASE_DIR}" -not -path '*/\.*' | sort)
  fi
  echo "$tree"
}


## ---- GET REALPATH ---- ##
# DEPENDENCIES:

get_realpath() {
  local path="$(echo "$1" | awk '{ gsub("/*$",""); print }')"
  [[ "$path" = /* ]] && echo "$path" || echo "$PWD/${path#./}"
}


## ---- GET RELATIVE PATH ---- ##
# DEPENDENCIES:

get_relative_path () {
  # PARSING
  local path="$1"
  local BASE_DIR="$(get_escaped_string "$2")"
  # FUNCTIONALITY
  echo "${path}" | awk '{ gsub("^'"${BASE_DIR}"'",""); gsub("^\/*",""); print }'
}


## ---- GET BACKUP PATH ---- ##
# DEPENDENCIES: checkers, getters

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


## ---- GET ESCAPED STRING ---- ##
# DEPENDENCIES:

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
