#!/bin/bash

# Usage: ./deploy_ipfs.sh
# Run this script after setup_ipfs_master.sh
# It requires that the master node has been set up with IPFS.

set -o allexport
source ~/fyp/scripts/bash_variables
set +o allexport

setup_bin=./setup_ipfs_worker.sh
chmod +x $setup_bin

# Grab peer ID of master node
peerID=`ipfs id | grep 'ID' | cut -d':' -f2 | cut -d'"' -f2`

for nodeIP in ${nodesIP[@]}; do
  ssh -T $nodeIP 'bash -s' < $setup_bin $peerID
done