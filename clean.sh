#!/bin/bash


my_dir="$(dirname "$0")"
source $my_dir/config.sh

if [[ $wd == "" ]]; then
  echo "Please specify working dir in config.sh"
  exit 1
fi

function clean {
  echo "-- $1 - Cleaning started..."
  output=`$ssh $username@$1 "rm -rf $wd; screen -XS oke quit >/dev/null 2>&1" 2>&1`
  if [[ $output == "" ]]; then
    echo "-- $1 - Success"
  else
    echo -e "-- $1 - OUTPUT:\n$output"
  fi
}

while read host; do
  if [[ $host =~ ^#.* ]] || [[ $host == '' ]]; then
    continue
  fi
  clean $host &
done < nodes.txt

# Wait for all processes processes to finish
wait
