#!/bin/bash

my_dir="$(dirname "$0")"
source $my_dir/config.sh

if [[ $wd == "" ]]; then
  echo "Please specify working dir in config.sh"
  exit 1
fi

function async_stop {
  echo "-- $1 - Stopping..."
  output=`ssh $username@$1 "bash $wd/stop.sh" 2>&1`
  if [[ $output == "" ]]; then
    echo "-- $1 - Success"
  else
    echo -e "-- $1 - Error\n$output"
  fi
}


while read host; do
  if [[ $host =~ ^#.* ]] || [[ $host == '' ]]; then
    continue
  fi
  async_stop $host &
done < nodes.txt

# Wait for all startup processes to finish
wait
