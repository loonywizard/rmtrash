#!/bin/bash

# We serve all files in /home/<username>/.trash directory
trashDirectoryPath=$HOME/.trash

# We need to delete file in directory, where script was called
# User passes filename to delete as first argument
fileToDeletePath=$(pwd)/$1

# if .trash directory doesn't exists
# -d file checks if file exists and it is a directory 
if [ ! -d "$trashDirectoryPath" ]; then
  mkdir "$trashDirectoryPath"
fi
