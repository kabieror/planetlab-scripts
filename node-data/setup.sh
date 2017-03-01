#!/bin/bash

my_dir="$(dirname "$0")"
source $my_dir/.config

cd $wd

hash yum 2>/dev/null && sudo yum update >/dev/null

hash screen 2>/dev/null || sudo yum --nogpgcheck -y install screen >> /dev/null

# Emerald-Runtime
hash emx 2>/dev/null || (rm -rf $wd/emerald; ln -s $wd/emerald ~/emerald)

