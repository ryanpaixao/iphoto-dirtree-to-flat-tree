#! /bin/bash

# Deletes Masters/ and all it's subdirectories

echo ""
echo "Are you sure you want to DELETE ALL of the files and directories in Masters/ !!?"
read -p "y or n? " resp
echo ""
case $resp in
  [y]* ) echo ".... Deleting all of Masters/" && rm -rf Masters/;;
  [n]* ) echo "Now exiting..." && exit;;
  *) echo "Not a valid response. Now exiting..."&& exit;;
esac
