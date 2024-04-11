#!/bin/sh

if [ $# -ne 1 ]; then
    echo "Usage: $0 <go-ethereum/erigon/prysm>"
    exit 1
fi

SRC_DIR=~/$1
DIR=~/ssc-eth-clients/data/capabilities
OUT="$DIR"/caps_"$1"_"$(date +%Y-%m-%d-%H)".json

mkdir -p "$DIR"
cd "$SRC_DIR" || exit 1
if [ -f "$OUT" ]; then 
    rm "$OUT"
fi

# todo: checkout upstream & pull
ALL=$(go list all)
for path in $ALL;
do
    capslock -packages="$path" -output=json >> "$OUT"
done

# todo: very large files as reoccurring packages included for all packages(e.g. flag pkg)
# THIS IS AN ISSUE