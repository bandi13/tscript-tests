#!/bin/bash

# This script will create a string of expected results from comments
# starting with > (ie. //>). This string will then be testing against 
# the actual results. If they match, nothing is printed; If they
# don't, "FAILED filename" is printed.

# Usage: checkResults.sh filename

if [ $# != 1 ] || [ ! -e $1 ]; then
  echo "Please pass a file or directory name to this script"
  exit 1;
fi

# Recurse through directories if one is given
if [ -d $1 ]; then
  find $1 -not -path $1 -exec $0 {} \;
fi

# Make sure we are operating on a file past here
if [ ! -f $1 ]; then
  exit 1;
fi

# Find all expected results
eResult=`sed -r -n 's:(.*)(//>)(.*):\3:p' $1`

# Get actual compiler output
aResult=`ts $1`

# Check if they are different and tell the caller
if [[ ! -z `diff -q <(echo $eResult) <(echo $aResult)` ]]; then
  echo "FAILED $1"
fi
