#! /bin/bash

############################
# This is script to create the dir tree structure and photos iphoto/Apple photos creates

# What an example path and file name looks like:
# Pictures/Photos Library. photoslibrary/Masters/2016/05/15/20160515-213349/IMG_3281.JPG
############################

startLocation=$(pwd)

# Make files
makeFiles() {
  local numOfFiles=5
  local name=$1
  local i=0

  for ((i=0; i<numOfFiles; i++))
    do
      touch ${name}photo_$((${i}+1)).jpg
    done

}

# Make directory
makeDirectory() {
  # Arguments
  local year=$1
  local month=$2
  local day=$3

  if (($2<10))
    then
      month=0$2
  fi

  if (($3<10))
    then
      day=0$3
  fi

  local location=Masters/${year}/${month}/$day/${year}${month}${day}-123456/

  mkdir -p $location
  makeFiles $location
}

# Make directory tree
makeTree() {
  # Arguments
  local interations=$1
  local i=0

  for ((i=0; i<interations; i++))
    do
      local year=$((2014+i))
      local month=$((1+i))
      local day=$((20+i))

      makeDirectory ${year} ${month} ${day}
    done
}

# Run makeTree
if [ $# -eq 0 ]
  then
    makeTree 4
else
  makeTree $1 
fi
