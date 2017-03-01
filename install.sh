#!/bin/bash

my_dir="$(dirname "$0")"
source $my_dir/config.sh

if [[ $wd == "" ]]; then
  echo "Please specify working dir in config.sh"
  exit 1
fi

rm -f node-data.tar
cd node-data

# Set working dir in node data
sed "s\\^wd=.*\$\\wd=$wd\\g" .config > .config.tmp
rm -f .config
mv .config.tmp .config

# Create tar archive
tar --dereference -cf ../node-data.tar . || (echo "Error while creating the archive"; exit 1)
cd ../

function install {
  echo "-- $1 - Installation started..."

  output=`$ssh $username@$1 "rm -rf $wd; mkdir -p $wd" 2>&1`
  if [[ $output != "" ]]; then
    echo "-- $1 - Error"
    echo $output
    return
  fi
  $scp -q node-data.tar $username@$1:$wd/node.tar
  output=`ssh $username@$1 "cd $wd && tar -xf node.tar && $wd/setup.sh" 2>&1`
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
