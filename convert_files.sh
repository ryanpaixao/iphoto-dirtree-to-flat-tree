#! /bin/bash

###################################################
# A bash script to convert the directory tree and image files created by iphoto in to a flat single directory.
# Script should be run from direct parent directory of 'Masters'
###################################################

startingDir=$(pwd)

############################
# functions
############################
checkIfValidPath() {
  [ -d $1 ]
}

convertFiles(){
  local srcPath=$1
  local destPath=$2

  echo ""

  if ! checkIfValidPath ${srcPath};
    then
      echo "'${srcPath}' is not a valid source Path!"      
  elif ! checkIfValidPath ${destPath}; 
    then
      echo "'${destPath}' is not a valid destination Path!"
  else
    echo "Converting from '${srcPath}' to '${destPath}'"
  fi
}

testingMode() {
  testPrep() {
    mkdir -p ./converted_files && ./testing_scripts/create_directory_tree.sh
  }

  # Give user testing mode info
  echo ""
  echo "=============================================================="
  echo "The default behavior (no argument supplied) is to run the TESTING version of convert_files.sh"
  echo ""
  echo "If you want to convert the files, supply both a source argument and a destination argument."
  echo "e.g. ./convert_files.sh ./myOldFiles ./myNewFiles/go/in/here"

  # Prompt user 
  echo ""
  echo "The test will create a ./Masters directory in the current directory."
  echo "As well as output the converted files in to the ./convert_files/ directory"
  echo ""
  echo "=============================================================="
  echo "Do you want to run a test?"
  read -p "y or n? " resp
  echo ""
  case $resp in
    [y]* ) testPrep && echo "Running the test..." && convertFiles ./Masters ./converted_files;;
    [n]* ) echo "Now exiting..." && exit;;
    *) echo "Not a valid response. Now exiting..."&& exit;;
  esac
}

############################
# Run script
############################

# Else there IS an ARGUMENT supplied
if [ $# -eq 2 ] 
  then
    local srcPath=$1
    local destPath=$2

    convertFiles srcPath destPath
# If there IS NO initial ARGUMENT supplied
else
  testingMode 
fi
