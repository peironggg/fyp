#!/bin/bash

WORK_DIR=~
declare -A filesystems
# hashmap value = filebench executable path
# filesystems["cephfs"]="$WORK_DIR/fyp/filebench/filebench"  # /mnt/cephfs
filesystems["ipfs"]="$WORK_DIR/fyp/filebench_ipfs/filebench_ipfs"  # /tmp
# filesystems["nativefs"]="$WORK_DIR/fyp/filebench/filebench"  # /tmp

for executable_path in ${filesystems[@]}; do
  sudo $executable_path -f $WORK_DIR/fyp/workloads/complete.f
done