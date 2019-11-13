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

## ---- IS EVEN ---- ##
# DEPENDENCIES:

is_even (){
  local number_of_directories="$1"
  if (( $number_of_directories % 2 != 0 )); then
    return 1  #FALSE
  else
    return 0  #TRUE
  fi
}


## ---- IS DIRECTORY ---- ##
# DEPENDENCIES:

is_directory (){
  # PARSING
  local directory="$1"
  # FUNCTIONALITY
  if [ ! -d "$directory" ]; then
    return 1  #FALSE
  else
    return 0  #TRUE
  fi
}


## ---- IS IN DIRECTORY ---- ##
# DEPENDENCIES:

is_in_directory () {
  # PARSING
  local target="$1"
  local TARGET_DIR="$2"
  # FUNCTIONALITY
  if [ -e "$target" ] && [[ "$target" == "${TARGET_DIR}/"* ]]; then
    return 0  #TRUE
  else
    return 1  #FALSE
  fi
}

## ---- IS IN SOURCE DIRECTORY ---- ##
# DEPENDENCIES: GLOBAL, checkers

is_in_source_directory () {
  # PARSING
  local target="$1"
  # FUNCTIONALITY
  local number_of_directories=${#DIRECTORY_PAIRS[@]}
  for (( i = 0; i < $number_of_directories; i+=2 )); do
    if is_in_directory "$target" "${DIRECTORY_PAIRS[$i]}"; then
      return 0  #TRUE
    else
      :
    fi
  done
  return 1  #FALSE
}

## ---- IS NEW FILE ---- ##
# DEPENDENCIES: etc, loggers

is_new_file () {
  # PARSING
  local source="$1"
  local backup="$2"
  # FUNCTIONALITY
  if [ ! -d "$source" ] && [ -d "$backup" ]; then
    error_log "CONFLICT: non-directory \"$source\" -> directory \"$backup\"."
    custom_exit 1
  elif [ ! -d "$source" ] && [ ! "$backup" -nt "$source" ]; then
    return 0  #TRUE
  else
    return 1  #FALSE
  fi
}

## ---- IS NEW SUBDIRECTORY ---- ##
# DEPENDENCIES: etc, loggers

is_new_subdirectory () {
  # PARSING
  local source="$1"
  local backup="$2"
  # FUNCTIONALITY
  if [ -d "$source" ] && [ ! -e "$backup" ]; then
    return 0  #TRUE
  elif [ -d "$source" ] && [ ! -d "$backup" ]; then
    error_log "CONFLICT: directory \"$source\" -> non-directory \"$backup\"."
    custom_exit 1
  else
    return 1  #FALSE
  fi
}
