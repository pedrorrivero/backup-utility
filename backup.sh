#!/usr/local/bin/bash

# ---------------------------------------- #
# Programer: PEDRO RIVERO
# Date: Nov 2 2019
# ---------------------------------------- #

TEST_SOURCE='./test'
TEST_BACKUP='./test.backup'

DIRECTORY_PAIRS=( $TEST_SOURCE $TEST_BACKUP)


## ---- OPTIONS ---- ##

OPTIONS=$@
LOG_FILE="./logs/$(date -u '+%Y-%m-%dT%H:%M:%SZ.log')"


## ---- LOGS ---- ##

# Uses global options and log
new_subdirectory_log () {
  # PARSING
  local backup=$1
  # FUNCTIONALITY
  local highlight="\t MAKING SUBDIRECTORY IN BACKUP: "
  local log=" $backup "
  test ! $QUIET && echo -e "$(tput setaf 3)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}

# Uses global options and log
backup_log () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2
  # FUNCTIONALITY
  local highlight=" BACKING-UP: "
  local log=" $SOURCE_DIR -> $BACKUP_DIR "
  test ! $QUIET && echo -e "$(tput setaf 6)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}

# Uses global options and log
file_log () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  local highlight="\t CREATING FILE BACKUP: "
  local log=" $source -> $backup "
  test ! $QUIET && echo -e "$(tput setaf 2)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}

# Uses global options and log
override_log () {
  # PARSING
  local backup=$1
  # FUNCTIONALITY
  local highlight=" OVERRIDING: "
  local log=" $backup "
  test ! $QUIET && echo -e "$(tput setaf 6)$highlight$(tput sgr 0)$log"
  test ! $NO_LOG && echo -e "$highlight$log" >> $LOG_FILE
}

# Uses global options and log
wipe_log () {
  # FUNCTIONALITY
  local log=" WIPING OUT BACKUP "
  test ! $QUIET && echo -e "$(tput setaf 6)$log$(tput sgr 0)"
  test ! $NO_LOG && echo -e $log >> $LOG_FILE
}

# Uses global options and log
warning_log () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local highlight=" WARNING: "
  echo -e "$(tput setab 1)$(tput setaf 7)$highlight"\
  "$(tput sgr 0)$message" >&2
  test ! $NO_LOG && echo -e "$highlight$message" >> $LOG_FILE
}

# Uses global options and log
error_log () {
  # PARSING
  local message=$1
  # FUNCTIONALITY
  local highlight=" ERROR: "
  echo -e "$(tput setab 1)$(tput setaf 7)$highlight"\
  "$(tput sgr 0)$(tput setaf 1)$message$(tput sgr 0)" >&2
  test ! $NO_LOG && echo -e "$highlight$message" >> $LOG_FILE
}


## ---- PARSER ---- ##

# Uses global options
option_parser () {

  while (( "$#" )); do
  case "$1" in
    -q|--quiet)
      QUIET='set'
      shift
      ;;
    -d|--dry-run)
      DRY_RUN='set'
      NO_LOG='set'
      echo -e "$(tput setab 7)$(tput setaf 0) DRY-RUN \n$(tput sgr 0)"
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
      echo -en "\n"

      shift
      exit 0
      ;;
    --) # end argument parsing
      shift
      break
      ;;
    -*|--*=) # unsupported flags
      error_log "Unsupported flag $1"
      exit 1
      ;;
    *) # preserve positional arguments
      MIRROR_DIRECTORIES="$MIRROR_DIRECTORIES $1"
      shift
      ;;
  esac
done

global_to_array "OVERRIDE"
global_to_array "MIRROR_DIRECTORIES"

}

# Uses global options
reset_options_and_arguments () {
  MIRROR_DIRECTORIES=""
  OVERRIDE=""

  QUIET=''
  DRY_RUN=''
  NO_LOG=''
  WIPE=''
  FORCE=''
}


## ---- FUNCTIONS ---- ##

# Uses global options
init_backup_mode () {
  tabs 4
  reset_options_and_arguments
  echo -en "\n"
}

# Uses global options and log
end_backup_mode () {
  if [ -z $NO_LOG ]
  then
    echo -e "\n$(tput setab 0)$(tput setaf 7) Logs saved to: $(tput sgr 0) $LOG_FILE \n"
  else
    echo -en "\n"
  fi
}

# Uses generic global
global_to_array () {
  # PARSING
  local global_name=$1
  # FUNCTIONALITY
  IFS=' ' read -ra $global_name <<< $(eval echo '$'$global_name)
}


get_sorted_tree () {
  # PARSING
  local BASE_DIR=$1
  # FUNCTIONALITY
  find ${BASE_DIR} | sort
}


get_relative_path () {
  # PARSING
  local source=$1
  local BASE_DIR=$2
  # FUNCTIONALITY
  echo ${source} | sed -e "s,^${BASE_DIR},," -e "s,^\/,,"
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
    return 0
  else
    return 1
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

# Uses global options
backup_if_new () {
  # PARSING
  local source=$1
  local backup=$2
  # FUNCTIONALITY
  if is_new_subdirectory $source $backup
  then
    new_subdirectory_log $backup
    test ! $DRY_RUN && mkdir $backup
  elif is_new_file $source $backup
  then
    file_log $source $backup
    test ! $DRY_RUN && cp $source $backup
  fi
}

# Uses global options (inherited)
do_backup () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2

  # FUNCTIONALITY
  backup_log $SOURCE_DIR $BACKUP_DIR
  local source_tree=($(get_sorted_tree ${SOURCE_DIR}))

  for source in "${source_tree[@]:1}"
  do
    local backup="${BACKUP_DIR}/$(get_relative_path $source $SOURCE_DIR)"
    backup_if_new $source $backup
  done
}

# Uses global options and log
create_log_file () {
  if [ -z $NO_LOG ]
  then
    mkdir ./logs 2> /dev/null
    touch $LOG_FILE 2> /dev/null
  fi
}

# Uses global options
override_if_requested () {
  # PARSING
  local target=$1
  # FUNCTIONALITY
  if [ -z $DRY_RUN ]
  then
    ask_confirmation "subdirectory override"
    rm -rf $target
  fi
}

# Uses global options
override_requested_subdirecrories () {
  # PARSING
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2
  # FUNCTIONALITY
  local target=''
  for subdirectory in "${OVERRIDE[@]}"
  do
    target="${BACKUP_DIR}/$(get_relative_path $subdirectory $SOURCE_DIR)"
    if [ -d $target ]
    then
      override_log $target
      override_if_requested $target
    else
      warning_log $subdirectory
    fi
  done
}

# Uses global options
wipe_backup_if_requested () {
  # PARSING
  local BACKUP_DIR=$1
  # FUNCTIONALITY
  if [ ! -z $WIPE ] && [ -z $DRY_RUN ]
  then
    wipe_log
    ask_confirmation "backup wipe"
    rm -rf $BACKUP_DIR/*
  fi
}


## ---- MAIN FUNCTION ---- ##

backup () {

  init_backup_mode
  option_parser $@

  local SOURCE_DIR=${MIRROR_DIRECTORIES[0]}
  local BACKUP_DIR=${MIRROR_DIRECTORIES[1]}

  create_log_file
  override_requested_subdirecrories $SOURCE_DIR $BACKUP_DIR
  wipe_backup_if_requested $BACKUP_DIR
  do_backup $SOURCE_DIR $BACKUP_DIR
  end_backup_mode

}


## ---- EXECUTION ---- ##

option_parser $OPTIONS > /dev/null
if [ ${#DIRECTORY_PAIRS[@]} == '0' ] && [ ${#MIRROR_DIRECTORIES[@]} == '0' ]
then
  echo -e "\n$(tput setaf 1)Invalid input: missing directory pair$(tput sgr 0)\n" >&2
  exit 1
elif [ ${#DIRECTORY_PAIRS[@]} == '0' ]
then
  backup $OPTIONS
else
  for (( i=0; i<${#DIRECTORY_PAIRS[@]}; i+=2 ));
  do

    SOURCE_DIR=${DIRECTORY_PAIRS[$i]}
    BACKUP_DIR=${DIRECTORY_PAIRS[$i+1]}

    backup $OPTIONS $SOURCE_DIR $BACKUP_DIR
  done
fi
