#!/bin/bash

# We serve all files in /home/<username>/.trash directory
trashDirectoryPath=$HOME/.trash

# We need to use unique identifier for removed file,
# It is a natural number, and we serve last used natural number
# in /home/<username>/.trash/.lastUsedId file
lastUsedIdPath=$trashDirectoryPath/.lastUsedId
LAST_USED_ID=0

# We need to delete file in directory, where script was called
# User passes filename to delete as first argument
fileToDeletePath=$(pwd)/$1

# We need to add information about deleted file to log file
# Log file: /home/<username>/.trash/.trash.log
logFilePath=$trashDirectoryPath/.trash.log

# -e file checks if file exists
if [ ! -e $fileToDeletePath ]; then
  echo "No such file: "$fileToDeletePath
  exit
fi

# if .trash directory doesn't exists
# -d file checks if file exists and it is a directory 
if [ ! -d "$trashDirectoryPath" ]; then
  mkdir "$trashDirectoryPath"
fi

if [ -e "$lastUsedIdPath" ]; then
  LAST_USED_ID=$(cat $lastUsedIdPath)
fi

# Id of current file to remove
let CURRENT_FILE_ID=LAST_USED_ID+1

# Write current id to .lastUsedId file
echo $CURRENT_FILE_ID > $lastUsedIdPath

# Create hard link to removing file
ln $fileToDeletePath $trashDirectoryPath/$CURRENT_FILE_ID

# Add info to .trash.log file
# the structure of file is
# fileToDeletePath:fileInTrashId
echo "${fileToDeletePath}:${CURRENT_FILE_ID}" >> $logFilePath

# remove file
rm $fileToDeletePath