#!/bin/bash

# Working dir on the node. Should be unique, to avoid conflicts with others working on the same node.
# e.g. /tmp/abcdefg
wd=

# The username to connect to the nodes.
# The user, that runs the planet lab scripts must already have SSH access to the nodes with the here specified username.
username=diku_INF5510v17

ssh="ssh -o StrictHostKeyChecking=no -o PasswordAuthentication=no"
scp="scp -o StrictHostKeyChecking=no -o PasswordAuthentication=no"
