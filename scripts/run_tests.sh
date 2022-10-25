#!/bin/bash

set -o allexport
source ~/fyp/scripts/bash_variables
set +o allexport

WORK_DIR=~
output_dir=test_results
num_trials=3

declare -A filesystems
# hashmap value = filebench executable path
# filesystems["cephfs"]="$WORK_DIR/fyp/filebench/filebench"  # /tmp
filesystems["ipfs"]="$WORK_DIR/fyp/filebench_ipfs/filebench_ipfs"  # /tmp
# filesystems["nativefs"]="$WORK_DIR/fyp/filebench/filebench"  # /tmp

# Workloads
workloads=("create_files.f" "delete.f" "random_read.f" "random_write.f" "seq_read.f" "seq_write.f")

# Create output folder
mkdir -p $output_dir

for fs in "${!filesystems[@]}"; do
  executable_path=${filesystems[$fs]}  

  # Setup
  if [ $fs = "cephfs" ]; then  
    sudo mount $cephfs_mountpoint
    # Set filesystem read,write,execute permissioning for user
    sudo chmod go+w $cephfs_mountpoint
  fi

  for ((i=0; i<$num_trials; i++)); do
    # Create and clear output file
    output_filename="$fs-$i"
    output_filepath=$output_dir/$output_filename
    touch $output_filepath
    > $output_filepath

    for workload in ${workloads[@]}; do
      printf "===========================================================================\n" >> $output_filepath
      printf "$workload\n" >> $output_filepath
      printf "===========================================================================\n" >> $output_filepath

      sudo $executable_path -f $WORK_DIR/fyp/workloads/$workload >> $output_filepath

      printf "===========================================================================\n" >> $output_filepath
      printf "===========================================================================\n" >> $output_filepath
    done  
done

  # Teardown
  if [ $fs = "cephfs" ]; then
    sudo umount $cephfs_mountpoint
  elif [ $fs = "ipfs" ]; then
    ipfs repo gc
  fi
done