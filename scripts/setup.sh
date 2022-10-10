#!/bin/bash

# Usage: ./setup.sh

# Setup filebench
setup_filebench=./filebench/setup_filebench.sh
chmod +x $setup_filebench
$setup_filebench

# Setup ipfs
ipfs_script_dir=./ipfs
chmod +x $ipfs_script_dir/setup_ipfs_master
chmod +x $ipfs_script_dir/deploy_ipfs.sh

$ipfs_script_dir/setup_ipfs_master
$ipfs_script_dir/deploy_ipfs.sh

# Setup cephfs
setup_cephfs=./cephfs/setup_cephfs_master
chmod +x $setup_cephfs
$setup_cephfs