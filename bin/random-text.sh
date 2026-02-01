#!/usr/bin/env bash

if [[ $1 == "--help" ]]; then
    echo "random-text.sh - Generates random text files from /dev/urandom"
    echo "Args: "
    echo "     <count> - Some nmber representing the size. I can't remember details."
    echo "     <output> - Output file"
    exit 0
fi

cat /dev/urandom | head -c $1 | tr -dc "A-Za-z0-9\n" | sort | uniq > $2
