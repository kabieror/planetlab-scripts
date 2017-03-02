#!/bin/bash

my_dir="$(dirname "$0")"
source $my_dir/config.sh

if [[ $wd == "" ]]; then
  echo "Please specify working dir in config.sh"
  exit 1
fi

if [[ $1 == "" ]]; then
  echo "Usage:"
  echo "    output.sh node.address.tld"
  exit 1
fi

$ssh -t $username@$1 "tail --follow=name $wd/output.log"

