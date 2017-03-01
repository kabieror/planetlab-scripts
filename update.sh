#!/bin/bash

my_dir="$(dirname "$0")"
source $my_dir/config.sh

if [[ $wd == "" ]]; then
  echo "Working directory not set"
  exit 1
fi

rm -f node-data.tar
cd node-data && tar --dereference -cf ../node-data.tar . || (echo "Error while creating the archive"; exit 1)
cd ../

function install {
  echo "-- $1 - Update started..."

  scp -q node-data.tar $username@$1:$wd/node.tar
  output=`ssh $username@$1 "cd $wd && tar -xf node.tar" 2>&1`
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
  install $host &
done < nodes.txt

# Wait for all installation processes to finish
wait
