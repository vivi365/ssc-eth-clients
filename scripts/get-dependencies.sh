#!/bin/sh

if [ $# -ne 1 ]; then
  echo "Usage: $0 <go-ethereum/erigon/prysm>"
  exit 1
fi

SRC_DIR=~/$1
DIR=~/ssc-eth-clients/data/dependencies
FILE_NAME="all_deps_$1_$(date +%Y-%m-%d-%H).txt"

mkdir -p "$DIR"
cd "$SRC_DIR" || exit 1

go list -m all | awk 'NR > 1 { print }' > "$DIR/$FILE_NAME"
echo "Total dependencies: $(wc -l < "$TARGET_FILE")"
