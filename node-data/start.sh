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
runstring=
if [[ $run == true ]]; then
  runstring=' Utils.x LogManager.x AsyncCollector.x Synchronizer.x Replication.x Main.x'
fi
screen -dmS $id bash -c "script -c 'emx -U -R$1$runstring 2>&1' -f $outfile"

if [[ $run == true ]]; then
  tail -f $outfile
else
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

