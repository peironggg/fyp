#!/bin/bash

# Usage: ./setup_cephfs_master.sh
# Installs cephadm on all nodes in cluster and adds them to cluster
# Create cephfs volume and mount on master node

cephfs_name=filebench_fs
mount_point=/mnt/ceph
install_cephadm_bin=./install_cephadm.sh
nodesIP=("10.10.1.2" "10.10.1.3")
declare -A hostnames
hostnames[10.10.1.2]="node1.peirong3-135472.simbricks-PG0.utah.cloudlab.us"
hostnames[10.10.1.3]="node2.peirong3-135472.simbricks-PG0.utah.cloudlab.us"

chmod +x $install_cephadm_bin

# Install cephadm
$install_cephadm_bin

# Install ceph CLI + mount.ceph helper + setfacl
sudo apt-get install ceph-common

# # Bootstrap ceph
sudo cephadm bootstrap --mon-ip 10.10.1.1 --allow-fqdn-hostname

# Add hosts to cluster
for nodeIP in ${nodesIP[@]}; do
  # Install cephadm on nodes
  ssh $nodeIP 'bash -s' < $install_cephadm_bin
  # Copy cluster public SSH key to node
  sudo ssh-copy-id -f -i /etc/ceph/ceph.pub root@$nodeIP
  # Tell ceph new node is part of cluster
  sudo ceph orch host add ${hostnames[$nodeIP]} $nodeIP
done

# Setup object storages for all devices
sudo ceph orch apply osd --all-available-devices

# Install cephfs
sudo ceph fs volume create $cephfs_name
sudo mkdir -p $mount_point

# Grab ceph secret
secret=$(sudo ceph auth get-key client.admin)

# Persist mount on reboots cephfs
sudo chmod 770 /etc/fstab
sudo printf ":/ $mount_point ceph name=admin,secret=$secret,noatime,_netdev,rw,acl 0 0\n" >> /etc/fstab

sudo mount $mount_point

# Set filesystem read,write,execute permissioning for user
sudo chmod go+w $mount_point