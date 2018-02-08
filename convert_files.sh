#! /bin/bash

###################################################
# A bash script to convert the directory tree and image files created by iphoto in to a flat single directory.
# Script should be run from direct parent directory of 'Masters'
###################################################

startingDir=$(pwd)

############################
# functions
############################
checkIfValidPaths() {
  local srcPath=$1
  local destPath=$2

  echo ""

  if ! [ -d ${srcPath} ];
    then
      echo "'${srcPath}' is not a valid source Path!"  
      return 1;
  elif ! [ -d ${destPath} ]; 
    then
      echo "'${destPath}' is not a valid destination Path!"
      return 1;
  else
    echo "Converting from '${srcPath}' to '${destPath}'"
    return 0;
  fi
}

copyAndRenameFile() {
  local fullPath=($1)
  local destPath=$2
  local originalName=""
  local updatedName=""
  local check=false

  # Create new file name from Path
  IFS='/' read -ra dirName <<< "$fullPath"
  for i in "${dirName[@]}"; do
    if ${check};
      then
        if [ "${updatedName}" == "" ]
          then
            updatedName=${i}
        else
          updatedName=${updatedName}-${i}
          originalName=${i}
        fi
    else
      if [ "${i}" == "Masters" ]
        then
          check=true
      fi
    fi
  done

  # Copy file to Dest dir. Rename file with new file name.
  if [ "${updatedName}" != "" ]
    then
      cp ${fullPath} ${destPath}/${updatedName}
  fi
  
}

treeCrawler() {
  cd $1
  local initialLocation=$(pwd)
  local localPaths=($(ls ${initialLocation}))
  local destPath=$2

  # while the localPaths.length is more than 0
  while [ ${#localPaths[@]} -gt 0 ]; do
    local newLocation=${initialLocation}/${localPaths[((${#localPaths[@]}-1))]}
    
    if [ -d ${newLocation} ];
      then
        cd ${newLocation};

        treeCrawler ${newLocation} ${destPath}
    else
      copyAndRenameFile ${newLocation} ${destPath}
    fi

    unset 'localPaths[((${#localPaths[@]}-1))]'
  done
}

convertFiles(){
  local srcPath=$1
  local destPath=$2

  if checkIfValidPaths ${srcPath} ${destPath};
    then
      cd $2 && destPath=$(pwd) && cd ..

      treeCrawler ${srcPath} ${destPath}
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
  echo ""
  read -p "Do you want to run a test?(y or n) " resp
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
    echo "$1 >>> $1"
    echo "$2 >>> $2"

    convertFiles $1 $2
# If there IS NO initial ARGUMENT supplied
else
  # REMOVE
  testingMode 
  # convertFiles ./Masters ./converted_files
fi
