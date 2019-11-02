#!/usr/local/bin/bash

SOURCE_DIR='./test'
BACKUP_DIR='./test.backup'

backup_new () {
  local SOURCE_DIR=$1
  local BACKUP_DIR=$2

  local source_tree=($(find ${SOURCE_DIR} | sort))
  local backup_tree=($(find ${BACKUP_DIR} | sort))

  echo -e " BACKING-UP: $SOURCE_DIR -> $BACKUP_DIR"

  for entry in "${source_tree[@]:1}"
  do
    local path=$(echo $entry | sed -e "s,^${SOURCE_DIR},," -e "s,^\/,,")
    local type=$(echo $entry | xargs file | sed -e "s,^${entry}\: ,,")

    local source="${SOURCE_DIR}/${path}"
    local backup="${BACKUP_DIR}/${path}"

    if [ $type == 'directory' ] && [ ! -d $backup ]
    then
      echo -e "\t MAKING DIRECTORY IN BACKUP: $backup"
      mkdir $backup
    elif [ $type != 'directory' ] && [ ! $backup -nt $source ]
    then
      echo -e "\t CREATING BACKUP: $source -> $backup"
      cp $source $backup
    fi
  done
}

## CODE TO EXECUTE ##
tabs 4
backup_new $SOURCE_DIR $BACKUP_DIR
