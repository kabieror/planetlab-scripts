#!/bin/bash

my_dir="$(dirname "$0")"
source $my_dir/.config
cd $wd

# Kill existing instances
screen -XS $id kill >/dev/null 2>&1
screen -XS $id quit >/dev/null 2>&1

if [[ $2 == "run" ]]; then
  run=true
fi

outfile=$wd/output.log
echo "" > $outfile

# Start new instance
if [[ $run == true ]]; then
  emx -U -R$1 main.x
else
  screen -dmS $id bash -c "script -c 'emx -U -R$1 2>&1' -f $outfile"
  # Wait for output of emx telling listening port
  for i in {1..4}; do
    output=$(cat $outfile | grep "Emerald listening" | head -n 1)
    if [[ $output != "" ]]; then
      echo $output
      exit 0
    fi
    sleep 1
  done

  # No output received
  cat $outfile
  exit 1
fi

