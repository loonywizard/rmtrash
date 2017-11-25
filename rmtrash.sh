#!/bin/bash

# if there's more that one argument or less
if [ $# -ne 1 ]; then
  echo "Program needs only one argument, aborting"
  exit
fi

# We serve all files in /home/<username>/.trash directory
TRASH_DIRECTORY_PATH=$HOME/.trash

FILENAME=$1

# We need to use unique identifier for removed file,
# It is a natural number, and we serve last used natural number
# in /home/<username>/.trash/.lastUsedId file
LAST_USED_ID_PATH=$TRASH_DIRECTORY_PATH/.lastUsedId
lastUsedId=0

# We need to delete file in directory, where script was called
# User passes filename to delete as first argument
FILE_PATH=$(pwd)/$FILENAME

# We need to add information about deleted file to log file
# Log file: /home/<username>/.trash/.trash.log
LOG_FILE_PATH=$TRASH_DIRECTORY_PATH/.trash.log

# -e file checks if file exists
if [ ! -e "$FILE_PATH" ]; then
  echo "No such file: "$FILE_PATH
  exit
fi

# check if user is trying to remove directory
if [ -d "$FILE_PATH" ]; then
  echo "Cannot delete a directory, aborting"
  exit
fi

# if .trash directory doesn't exists
# -d file checks if file exists and it is a directory 
if [ ! -d "$TRASH_DIRECTORY_PATH" ]; then
  mkdir "$TRASH_DIRECTORY_PATH"
fi

if [ -e "$LAST_USED_ID_PATH" ]; then
  lastUsedId=$(cat $LAST_USED_ID_PATH)
fi

# Id of current file to remove
let CURRENT_FILE_ID=lastUsedId+1

# Write current id to .lastUsedId file
echo $CURRENT_FILE_ID > $LAST_USED_ID_PATH

# Create hard link to removing file
ln "$FILE_PATH" "$TRASH_DIRECTORY_PATH/$CURRENT_FILE_ID"

# Add info to .trash.log file
# the structure of file is
# fileDirectory:filename:fileInTrashId
echo "$(pwd):$FILENAME:$CURRENT_FILE_ID" >> $LOG_FILE_PATH

# remove file
rm "$FILE_PATH"