#!/bin/bash

# Usage: ./setup_cephfs_master.sh
# Installs cephadm on all nodes in cluster and adds them to cluster
# Create cephfs volume and mount on master node

set -o allexport
source ~/fyp/scripts/bash_variables
set +o allexport

cephfs_name=filebench_fs
install_cephadm_bin=./install_cephadm.sh

declare -A hostnames
hostnames[10.10.1.2]="pc203"
hostnames[10.10.1.3]="pc201"
hostnames[10.10.1.4]="pc204"

chmod +x $install_cephadm_bin

# Install cephadm
$install_cephadm_bin

# Install ceph CLI + mount.ceph helper + setfacl
sudo apt-get install ceph-common

# # Bootstrap ceph
sudo cephadm bootstrap --mon-ip 10.10.1.1

# Add hosts to cluster
for nodeIP in ${nodesIP[@]}; do
  # Install cephadm on nodes
  ssh $nodeIP 'bash -s' < $install_cephadm_bin
  # Copy cluster public SSH key to node
  sudo ssh-copy-id -f -i /etc/ceph/ceph.pub root@$nodeIP
  # Tell ceph new node is part of cluster
  sudo ceph orch host add ${hostnames[$nodeIP]} $nodeIP
done

# Setup object storages for all worker nodes
for nodeIP in ${nodesIP[@]}; do
  sudo ceph orch daemon add osd ${hostnames[$nodeIP]}:/dev/sdb
done

# Create cephfs
sudo ceph fs volume create $cephfs_name

# Grab ceph secret
secret=$(sudo ceph auth get-key client.admin)

# Persist mount on reboots cephfs
sudo chmod 770 /etc/fstab
sudo printf ":/ $cephfs_mountpoint ceph name=admin,secret=$secret,noatime,_netdev,rw,acl 0 0\n" >> /etc/fstab