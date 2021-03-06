#! /bin/bash

###################################################
# A bash script to convert the directory tree and image files created by iphoto in to a flat single directory.
# Script should be run from direct parent directory of 'Masters'
###################################################


############################
# functions
############################
checkIfValidPaths() {
  local srcPath="${1}"
  local destPath="${2}"

  echo ""

  if ! [ -d "${srcPath}" ];
    then
      echo "${srcPath}"" is not a valid source Path!"  
      echo ""
      return 1;
  elif ! [ -d "${destPath}" ]; 
    then
      echo "${destPath}"" is not a valid destination Path!"
      echo ""
      return 1;
  else
    echo "Converting from '""${srcPath}""' to '""${destPath}""'"
    echo ""
    return 0;
  fi
}

copyErrorHandling() {
  local fullPath="${1}"
  local destPath="${2}"
  local updatedName="${3}"

  echo "" >> "${destPath}"/convert_files_error.log
  echo "ERROR!! copying: " >> "${destPath}"/convert_files_error.log
  echo "   SOURCE: ""${fullPath}" >> "${destPath}"/convert_files_error.log
  echo "       ->    " >> "${destPath}"/convert_files_error.log
  echo "   DESTINATION: ""${destPath}"/"${updatedName}" >> "${destPath}"/convert_files_error.log
  echo "" >> "${destPath}"/convert_files_error.log
}

copyAndRenameFile() {
  local fullPath=("${1}")
  local destPath="${2}"
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
            updatedName="${i}"
        else
          updatedName="${updatedName}"-"${i}"
          originalName="${i}"
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
      # Actual copy command
      cp -v "${fullPath}" "${destPath}"/"${updatedName}"

      # Check if cp spit out an error
      if [ "$?" != "0" ];
        then
          copyErrorHandling "${fullPath}" "${destPath}" "${updatedName}"
      fi
  fi
  
}

treeCrawler() {
  cd "${1}"
  local initialLocation=$(pwd)

  # Set IFS to a return charcter, set for `ls` as well as array creation
  IFS=$'\n'

  local localPaths=($(ls "${initialLocation}"))
  local destPath="${2}"

  # while the localPaths.length is more than 0
  while [ ${#localPaths[@]} -gt 0 ]; do
    local newLocation="${initialLocation}"/${localPaths[((${#localPaths[@]}-1))]}
    
    if [ -d "${newLocation}" ];
      then
        cd "${newLocation}";

        treeCrawler "${newLocation}" "${destPath}"
    else
      copyAndRenameFile "${newLocation}" "${destPath}"
    fi

    unset 'localPaths[((${#localPaths[@]}-1))]'
  done

  # Set IFS back to default
  IFS=$' \t\n'
}

convertFiles(){
  local srcPath="${1}"
  local destPath="${2}"

  if checkIfValidPaths "${srcPath}" "${destPath}";
    then
      cd "${2}" && destPath=$(pwd) && cd ..
      dt=$(date '+%d/%m/%Y %H:%M:%S');
      
      # Remove old convert_files_error.log
      # And create a new one with time and date
      if [ -f "${destPath}"/convert_files_error.log ];
        then
          rm "${destPath}"/convert_files_error.log
      fi
      echo "File Generated at: (Day, Month, Year) ${dt}" >> "${destPath}"/convert_files_error.log

      treeCrawler "${srcPath}" "${destPath}"
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
    convertFiles "${1}" "${2}"
# If there IS NO initial ARGUMENT supplied
else
  testingMode 
fi
