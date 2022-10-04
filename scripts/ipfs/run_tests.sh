#!/bin/bash

WORK_DIR=~
declare -A filesystems
# hashmap value = filebench executable path
# filesystems["cephfs"]=("$WORK_DIR/filebench/filebench" "/mnt/cephfs")
# filesystems["ipfs"]=("$WORK_DIR/filebench_ipfs/filebench_ipfs" "/tmp")
filesystems["nativefs"]="$WORK_DIR/filebench/filebench"

for executable_path in ${filesystems[@]}; do
  sudo $executable_path -f $WORK_DIR/ipfs_c_client/workloads/complete.f
done