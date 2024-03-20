#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $0 <go-ethereum/erigon/prysm>"
    exit 1
fi

SRC_DIR=~/$1
DIR=~/ssc-thesis/data/capabilities

mkdir -p "$DIR"
cd "$SRC_DIR" || exit 1

# todo: does not pull changes from remote
# todo: all packages in a module. 
# go mod tidy
capslock -output=v > "$DIR"/caps_"$1"_"$(date +%Y-%m-%d-%H)".txt