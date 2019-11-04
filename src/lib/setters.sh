#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

# Uses generic global
global_to_array () {
  # PARSING
  local global_name=$1
  # FUNCTIONALITY
  IFS=' ' read -ra $global_name <<< $(eval echo '$'$global_name)
}
