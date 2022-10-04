#!/bin/bash

# Usage: ./setup_cephfs_master.sh
# Installs cephadm on all nodes in cluster and adds them to cluster
# Create cephfs volume and mount on master node

cephfs_name=filebench_fs
install_cephadm_bin=./install_cephadm_bin.sh
nodesIP=("10.10.1.2" "10.10.1.3")
declare -A hostnames
hostnames[10.10.1.2]=test1
hostnames[10.10.1.3]=test2

chmod +x $install_cephadm_bin

# Install cephadm
$install_cephadm_bin

# Add hosts to cluster
for nodeIP in ${nodesIP[@]}; do
  # Install cephadm on nodes
  ssh $nodeIP 'bash -s' < $install_cephadm_bin
  # Copy cluster public SSH key to node
  ssh-copy-id -f -i /etc/ceph/ceph.pub root@$nodeIP
  # Tell ceph new node is part of cluster
  ceph orch host add hostnames[$nodeIP] $nodeIP

# Bootstrap ceph
cephadm bootstrap --mon-ip 10.10.1.1

# Install cephfs
ceph fs volume create $cephfs_name
mkdir -p /mnt/cephfs
secret=sudo cat /etc/ceph/ceph.client.admin.keyring | grep key | cut -d= -f2
sudo mount -t ceph admin@.$cephfs_name-fs=/ /mnt/cephfs -o secret=$secret==

# Set filesystem read,write,execute permissioning for user