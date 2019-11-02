#!/usr/local/bin/bash

SOURCE_DIR='./test'
BACKUP_DIR='./test.backup'

source_tree=($(find ${SOURCE_DIR} | sort))
backup_tree=($(find ${BACKUP_DIR} | sort))

echo -e " BACKING-UP: $SOURCE_DIR -> $BACKUP_DIR"

for entry in "${source_tree[@]:1}"
do
  name=$(echo $entry | sed -e "s,^${SOURCE_DIR},," -e "s,^\/,,")
  type=$(echo $entry | xargs file | sed -e "s,^${entry}\: ,,")
  # echo "${name}: ${type}"

  source="${SOURCE_DIR}/${name}"
  backup="${BACKUP_DIR}/${name}"

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
