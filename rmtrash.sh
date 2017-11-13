#!/bin/bash

trashDirectoryPath=$HOME/.trash

# if .trash directory doesn't exists
# -d file checks if file exists and it is a directory 
if [ ! -d "$trashDirectoryPath" ]; then
  mkdir "$trashDirectoryPath"
fi