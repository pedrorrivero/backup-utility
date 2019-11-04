#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 3 2019
# ---------------------------------------- #

## ---- PARSER ---- ##

# Uses global options
argument_parser () {

  while (( "$#" )); do
  case "$1" in
    -q|--quiet)
      QUIET='set'
      shift
      ;;
    -d|--dry-run)
      DRY_RUN='set'
      NO_LOG='set'
      echo -e "$(tput setab 7)$(tput setaf 0) DRY-RUN $(tput sgr 0)\n"
      shift
      ;;
    -n|--no-log)
      NO_LOG='set'
      shift
      ;;
    -o|--override)
      OVERRIDE="$OVERRIDE $2"
      shift 2
      ;;
    -w|--wipe-backup)
      WIPE='set'
      shift
      ;;
    -f|--force)
      FORCE='set'
      shift
      ;;
    -h|--help)

      echo -e "BACKUP UTILITY:"\
      "backup [options] <SOURCE_DIR> <BACKUP_DIR> \n"
      echo -e "\t -q  --quiet: \t "\
      "Do not log to stdout."
      echo -e "\t -d  --dry-run: \t "\
      "Show changes to be made without actually running them."
      echo -e "\t -n  --no-log: \t "\
      "Do not create log file."
      echo -e "\t -o  --override <subdirectory>: \t "\
      "Discard previous backup files for a given subdirectory."
      echo -e "\t -w  --wipe-backup: \t "\
      "Wipe clean all previous backups before running."
      echo -e "\t -f  --force: \t "\
      "Do not prompt confirmation dialog."
      echo -e "\t -h  --help: \t "\
      "Display this help. "

      custom_exit 0
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      error_log "Unsupported flag $1"
      custom_exit 1
      ;;
    *) # preserve positional arguments
      DIRECTORY_PAIRS="$DIRECTORY_PAIRS $1"
      shift
      ;;
  esac
done

standardize_global "OVERRIDE"
standardize_global "DIRECTORY_PAIRS"

verify_arguments

}

# Uses global options
standardize_global () {
  # PARSING
  local global_name=$1
  # FUNCTIONALITY
  global_to_array $global_name
  local global_size=$(eval echo '${#'$global_name'[@]}')
  for (( i=0; i<$global_size; i++ )); do
    eval $global_name'['$i']=$(get_realpath ${'$global_name'['$i']})'
  done
}

# Uses global options
verify_arguments (){
  local number_of_directories=${#DIRECTORY_PAIRS[@]}
  verify_argument_number $number_of_directories
  for (( i = 0; i < $number_of_directories; i++ )); do
    verify_argument_kind ${DIRECTORY_PAIRS[$i]}
  done
}

# Uses global options
reset_options () {
  OVERRIDE=""

  QUIET=''
  DRY_RUN=''
  NO_LOG=''
  WIPE=''
  FORCE=''
}

# Uses generic global
global_to_array () {
  # PARSING
  local global_name=$1
  # FUNCTIONALITY
  IFS=' ' read -ra $global_name <<< $(eval echo '$'$global_name)
}

# Uses global options
verify_argument_number (){
  local number_of_directories=$1
  if (( $number_of_directories % 2 != 0 ))
  then
    error_log "Not a backup location for each source directory."
    custom_exit 1
  else
    return 0
  fi
}

# Uses global options
verify_argument_kind (){
  local directory=$1
  if [ ! -d $directory ]; then
    error_log "\"$directory\" is not a directory."
    custom_exit 1
  else
    return 0
  fi
}

# Uses global options
ask_confirmation () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local confirmation=''
  if [ -z $FORCE ]
  then
    while ! confirm_answer $confirmation
    do
      read -p "Confirm $1 [y/n]: " confirmation
    done
  fi
}


confirm_answer () {
  # PARSING
  local confirmation=$1
  # FUNCTIONALITY
  if [[ $confirmation == 'n' ]] || [[ $confirmation == 'N' ]]
  then
    echo -e "Backup cancelled... \n"
    exit 0
  elif [[ $confirmation == 'y' ]] || [[ $confirmation == 'Y' ]]
  then
    return 0  #TRUE
  else
    return 1  #FALSE
  fi
}
