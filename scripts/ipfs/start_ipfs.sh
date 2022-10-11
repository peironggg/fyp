#!/bin/bash

# Usage: ./start_ipfs.sh
# Start ipfs in all nodes in cluster

set -o allexport
source ~/fyp/scripts/bash_variables
set +o allexport

for nodeIP in ${nodesIP[@]}; do
  ssh -T $nodeIP "ipfs daemon --enable-gc"
done

ipfs daemon --enable-gc