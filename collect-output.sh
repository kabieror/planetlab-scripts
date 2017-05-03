#!/bin/bash

my_dir="$(dirname "$0")"
source $my_dir/config.sh

if [[ $wd == "" ]]; then
  echo "Please specify working dir in config.sh"
  exit 1
fi


# Make new dir
outputDirName="output $(date "+%Y-%m-%d %H-%M-%S")"
mkdir "$outputDirName"

function async_collect {
  echo "-- $1 - Collecting..."
  output=`rsync -q "$username@$1:$wd/output.log" "$outputDirName/$1.log" 2>&1`
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
  async_collect $host &
done < nodes.txt

# Wait for all processes to finish
wait
