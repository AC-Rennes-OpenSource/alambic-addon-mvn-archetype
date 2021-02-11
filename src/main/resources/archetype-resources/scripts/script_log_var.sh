#!/bin/bash

#----------------------------------------------
# Description
# This addon's script aims to ...
#----------------------------------------------
VERBOSE=0

#----------------------------------------------
# functions
#----------------------------------------------
logger() {
  if [ "ERROR" = $1 ] || [ "WARN" = $1 ] || [ $VERBOSE -eq 2 ] || [ $1 = "INFO" -a $VERBOSE -eq 1 ]
  then
    echo "[$1]" $2
  fi
}

usage() {
  echo "Usage: \"$0 [-v (verbose) -d (debug)]\""
}

finally() {
  logger "INFO" "Completed processing"
  exit $1
}

#---------------------------------------------
# Parse script's options 
#---------------------------------------------
if [ $# -ge 1 ]
then
  # parse the command options
  while getopts "vd" opt
  do
    case $opt in
      v)
        # enable verbose simple logs
        VERBOSE=1
        ;;
      d)
        # enable debug logs
        VERBOSE=2
        ;;
      \?)
        logger "ERROR" "Invalid argument: -$OPTARG" >&2
        usage
        finally 1
        ;;
    esac
  done
fi

#----------------------------------------------
# Processing
#----------------------------------------------
{
    echo ${addon_var}
} > script_log_var.log 2>&1

finally 0
