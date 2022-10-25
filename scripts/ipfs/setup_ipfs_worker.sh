#!/bin/sh

# Usage: ./setup_ipfs_worker.sh <master node peerID>
# This script should be called on the worker node but
# it is easier to call deploy_ipfs.sh on the master node instead.

WORK_DIR=~

cd $WORK_DIR

# Install IPFS
wget https://dist.ipfs.tech/kubo/v0.15.0/kubo_v0.15.0_linux-amd64.tar.gz
tar -xvzf kubo_v0.15.0_linux-amd64.tar.gz
cd kubo
sudo bash install.sh

cd $WORK_DIR
rm -rf kubo*

# # Setup IPFS private network
ipfs init
ipfs bootstrap rm --all

# Fetch swarm key from master
sudo scp root@10.10.1.1:/users/peirong3/.ipfs/swarm.key ~/.ipfs
ipfs bootstrap add /ip4/10.10.1.1/tcp/4001/ipfs/$1

# Disable local caching
ipfs config --json Datastore.StorageGCWatermark 0

bash -c "export LIBP2P_FORCE_PNET=1"
