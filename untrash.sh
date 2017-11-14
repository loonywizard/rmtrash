#!/bin/bash

FILENAME_TO_RESTORE=$1
TRASH_DIRECTORY_PATH=$HOME/.trash
LOG_FILE_PATH=$TRASH_DIRECTORY_PATH/.trash.log

LOG_FILE_DATA="$(< $LOG_FILE_PATH)"

index=1

for line in $LOG_FILE_DATA; do
  # -F in awk is --field-separator
  directory=$(echo $line | awk -F':' '{ print $1 }')
  FILENAME=$(echo $line | awk -F':' '{ print $2 }')
  FILE_ID=$(echo $line | awk -F':' '{ print $3 }')

  if [ $FILENAME_TO_RESTORE == $FILENAME ]; then
    read -p "Do you want to restore "$directory"/"$FILENAME"? [Y/n]" response
    
    if [ $(echo $response | awk '{ print toupper($0) }') == "Y" ]; then
      
      # check if directory exists
      if [ ! -d "$directory" ]; then
        echo "$directory is no longer a directory, restoring to $HOME"
        directory=$HOME
      fi

      # check if there's already file with that filename
      if [ -e $directory"/"$FILENAME ]; then
        echo "$directory"/"$FILENAME is already exists, aborting"
        exit
      fi

      # create hard link
      ln $TRASH_DIRECTORY_PATH/$FILE_ID $directory/$FILENAME

      # remove a line from log file
      echo "$(sed "${index} d" $LOG_FILE_PATH)" > $LOG_FILE_PATH
    fi
  fi

  let index=$index+1
done