#!/bin/bash

# loop over the dotfiles in ~/dotfiles/config and create a symlink to them in ~
# If the file exists make a backup prior to symlinking
for I in $(find config); do 
  # we handle only files
  if [ -f $I ];then
    FILE=$(basename -- "$I")
    echo Handling $FILE
    # check if ~/$FILE is a symlink
    if [ -L "$HOME/$FILE" ];then
      echo Skipping $HOME/$FILE as it is already a symlink
    else
      if [ -f "$HOME/$FILE" ];then
        echo $HOME/$FILE must be backed-up
        DATE=$(date +%Y-%m-%d_%H-%M)
        echo create a backup to $HOME/$FILE to $HOME/$FILE_$DATE
        mv $HOME/$FILE $HOME/$FILE_$DATE
      fi
      ln -s $PWD/$I ~/$FILE
    fi
  fi
done

