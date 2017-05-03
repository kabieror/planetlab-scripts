#!/bin/bash

my_dir="$(dirname "$0")"
source $my_dir/.config

screen -XS $id kill 
screen -XS $id quit 
