#!/bin/bash

set -o allexport
source ~/fyp/scripts/bash_variables
set +o allexport

WORK_DIR=~
output_dir=test_results

declare -A filesystems
# hashmap value = filebench executable path
# filesystems["cephfs"]="$WORK_DIR/fyp/filebench/filebench"  # /tmp
# filesystems["ipfs"]="$WORK_DIR/fyp/filebench_ipfs/filebench_ipfs"  # /tmp
filesystems["nativefs"]="$WORK_DIR/fyp/filebench/filebench"  # /tmp

# Workloads
workloads=("create_files.f" "delete.f" "random_read.f" "random_write.f" "seq_read.f" "seq_write.f")

# Create output folder
mkdir -p $output_dir

for fs in "${!filesystems[@]}"; do
  executable_path=${filesystems[$fs]}
  output_file=$output_dir/$fs

  # Setup
  if [ $fs = "cephfs" ]; then  
    sudo mount $cephfs_mountpoint
    # Set filesystem read,write,execute permissioning for user
    sudo chmod go+w $cephfs_mountpoint
  fi

  # Create and clear output file
  touch $output_file
  > $output_file

  for workload in ${workloads[@]}; do
    printf "===========================================================================\n" >> $output_file
    printf "$workload\n" >> $output_file
    printf "===========================================================================\n" >> $output_file

    sudo $executable_path -f $WORK_DIR/fyp/workloads/$workload >> $output_file

    printf "===========================================================================\n" >> $output_file
    printf "===========================================================================\n" >> $output_file
  done  

  # Teardown
  if [ $fs = "cephfs" ]; then
    sudo umount $cephfs_mountpoint
  elif [ $fs = "ipfs" ]; then
    ipfs repo gc
  fi
done