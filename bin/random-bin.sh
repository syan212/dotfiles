#!/usr/bin/env bash

if [[ $1 == "--help" ]]; then
    echo "random-bin.sh - Generates a random binary file from /dev/urandom of specified size"
    echo "Args: "
    echo "     <count> - Size of output file in megabytes"
    echo "     <output> - Output file"
    exit 0
fi

dd if=/dev/urandom of=$2 bs=1M count=$1  
