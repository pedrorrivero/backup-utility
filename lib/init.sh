#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 4 2019
# ---------------------------------------- #

## ---- FUNCTIONS ---- ##

# Uses init and setters
init_backup_mode () {
  # PARSING
  local ARGS="$@"
  # FUNCTIONALITY
  tabs 4
  reset_options
  argument_parser "$ARGS"
  create_log_file
  echo_backup_briefing
}

# Uses global options, etc and init
argument_parser () {

  while (( "$#" )); do
  case "$1" in
    -q|--quiet)
      QUIET='set'
      shift
      ;;
    -d|--dry-run)
      DRY_RUN='set'
      LOG=''
      echo -e "\n$(tput setab 7)$(tput setaf 0) DRY-RUN $(tput sgr 0)"
      shift
      ;;
    -n|--no-log)
      LOG=''
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
    -i|--include-hidden)
      HIDDEN='set'
      shift
      ;;
    -h|--help)

      echo -e "\nBACKUP UTILITY:"\
      "backup [options] <SOURCE_DIR> <BACKUP_DIR> \n"
      echo -e "\t -q  --quiet: \t "\
      "Do not log individual file/dir backups to stdout."
      echo -e "\t -d  --dry-run: \t "\
      "Show changes to be made without actually running them."
      echo -e "\t -n  --no-log: \t "\
      "Do not create log file."
      echo -e "\t -o  --override <file/subdirectory>: \t "\
      "Discard previous backup file/subdirectory for a given source."
      echo -e "\t -w  --wipe-backup: \t "\
      "Wipe clean all previous backups before running."
      echo -e "\t -f  --force: \t "\
      "Do not prompt confirmation dialog."
      echo -e "\t -i  --include-hidden: \t "\
      "Backup hidden files as well."
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

standardize_global_dir_array "OVERRIDE"
standardize_global_dir_array "DIRECTORY_PAIRS"

verify_directories
verify_overrides

}

# Uses global options and log
create_log_file () {
  if [ ! -z "$LOG" ]
  then
    mkdir "$LOG_DIRECTORY" 2> /dev/null
    touch "$LOG_FILE" 2> /dev/null
  fi
}

echo_backup_briefing () {
  echo -e "\n$(tput setab 4)BACKUP BRIEFING$(tput sgr 0)"
  IFS=$'\n'
  local number_of_directories="${#DIRECTORY_PAIRS[@]}"
  for (( i = 0; i < $number_of_directories; i+=2 )); do
    echo "    ${DIRECTORY_PAIRS[$i]} $(tput setaf 4)->$(tput sgr 0) ${DIRECTORY_PAIRS[$i+1]}"
  done
  echo -en "\n"
}

# Uses global options, getters and setters
standardize_global_dir_array () {
  # PARSING
  local global_name="$1"
  # FUNCTIONALITY
  set_global_to_array "$global_name"
  local global_size="$(eval echo '${#'$global_name'[@]}')"
  for (( i=0; i<$global_size; i++ )); do
    eval $global_name'['$i']=$(get_realpath ${'$global_name'['$i']})'
  done
}

# Uses global options, checkers, etc and loggers
verify_directories () {
  local number_of_directories="${#DIRECTORY_PAIRS[@]}"
  if ! is_even "$number_of_directories"; then
    error_log "Not a backup location for each source directory."
    custom_exit 1
  fi
  for (( i = 0; i < $number_of_directories; i++ )); do
    if ! is_directory "${DIRECTORY_PAIRS[$i]}"; then
      error_log "\"${DIRECTORY_PAIRS[$i]}\" is not a directory."
      custom_exit 1
    fi
  done
}

# Uses global options, checkers and loggers
verify_overrides () {
  local number_of_overrides=${#OVERRIDE[@]}
  for (( i = 0; i < $number_of_overrides; i++ )); do
    if ! is_in_source_directory "${OVERRIDE[$i]}"
    then
      warning_log "OVERRIDE FAILED: \"${OVERRIDE[$i]}\" is not in any source."
    fi
  done
}
