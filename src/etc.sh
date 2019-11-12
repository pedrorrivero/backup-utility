#!/usr/local/bin/bash

#    _____  _____
#   |  __ \|  __ \    AUTHOR: Pedro Rivero
#   | |__) | |__) |   ---------------------------------
#   |  ___/|  _  /    DATE: November 12, 2019
#   | |    | | \ \    ---------------------------------
#   |_|    |_|  \_\   https://github.com/pedrorrivero
#

# ---------------------------------------- #
#                FUNCTIONS                 #
# ---------------------------------------- #

## ---- CUSTOM EXIT ---- ##
# DEPENDENCIES:

custom_exit () {
  echo -en "\n"
  exit "$@"
}
