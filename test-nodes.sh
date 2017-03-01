#!/bin/bash

if [[ $1 == "" ]]; then
  echo "Usage:"
  echo "    ./test-nodes.sh path/to/nodes.txt"
  exit 1
fi

while read node; do
  if [[ $node =~ ^#.* ]] || [[ $node == '' ]]; then
    continue
  fi
  ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=no diku_INF5510v17@$node "echo $node" 2>/dev/null </dev/null &
done < $1

wait
