#!/bin/bash

# Usage: ./setup_filebench.sh

WORK_DIR=~

# Install libcurl for client HTTP requests
sudo apt-get install libcurl4-openssl-dev

# Update git submodules
git submodule init
git submodule update

# Install own forked version of filebench_ipfs and filebench
filebench_vs=("filebench_ipfs" "filebench")

for filebench in ${filebench_vs[@]}; do
  cd $WORK_DIR/fyp/$filebench

  libtoolize
  aclocal
  autoheader
  automake --add-missing
  autoconf

  ./configure
  make
done

# Disable randomize_va_space
sudo sysctl -w kernel.randomize_va_space=0