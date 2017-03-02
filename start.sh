#!/bin/bash

my_dir="$(dirname "$0")"
source $my_dir/config.sh

if [[ $wd == "" ]]; then
  echo "Please specify working dir in config.sh"
  exit 1
fi

startnode=
connectstring=
fast=false

if [[ $1 == "-f" ]]; then
  connectstring=`cat .connectstring`
  if [[ $connectstring == "" ]]; then
    echo "No previous execution. Please start without '-f' flag."
    exit 1
  fi
  fast=true
fi


function async_start {
  echo "-- $1 - Connecting to $connectstring..."
  output=`$ssh $username@$1 "bash $wd/start.sh $connectstring" 2>&1`
  if [[ $output == "" ]] || [[ $output =~ port[[:space:]]([[:digit:]]+) ]] ; then
    echo "-- $1 - Started with connection to first node"
  else
    echo -e "-- $1 - Error\n$output"
  fi
}

while read host; do
  if [[ $host =~ ^#.* ]] || [[ $host == '' ]]; then
    continue
  fi
  if [[ $startnode == "" ]]; then
    startnode=$host
    continue
  fi
  if [[ $startnode == $host ]]; then
    continue
  fi
  if [[ $fast == true ]]; then
    # If fast mode is set, do not start all nodes except the main node
    break
  fi
  if [[ $connectstring == '' ]]; then
    # Start first instance
    echo "-- $host - Starting up"
    startres=`$ssh $username@$host "bash $wd/start.sh" 2>&1 </dev/null`
    if [[ $startres =~ port[[:space:]]([[:digit:]]+) ]]; then
      echo "-- $host - Started on port ${BASH_REMATCH[1]}"
      connectstring="$host:${BASH_REMATCH[1]}"
      echo "$connectstring" > .connectstring
    else
      echo "-- $host - Could not start as first node."
      echo "$startres"
    fi
  else
    # Connect instance to existing one
    async_start $host &
  fi
done < nodes.txt

# Wait for all startup processes to finish
wait

# Start main program
echo "-- $startnode - Starting main node"
$ssh $username@$startnode "$wd/start.sh $connectstring run"
