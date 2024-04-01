#!/bin/bash

DIR="ssc-eth-clients/data/repo"
ETH="$HOME/go-ethereum"
OUT="$HOME/$DIR/eth-langs.txt"
rm "$OUT"

# get langs by curl https://api.github.com/repos/ethereum/go-ethereum/languages

LANGS=("Go" "C" "JavaScript" "Assembly" "Shell" "Java" "Sage" "M4" "NSIS" "Python" "Solidity" "Makefile" "HTML" "Dockerfile")
LANGS_POSTFIX=("\.go$" "\.[ch]$" "\.js$" "\.s$" "\.sh$" "\.java$" "\.sage$" "\.m4$" "\.ns[ih]$" "\.py$" "\.sol$" "Makefile$" "html$" "Dockerfile[.alltools]*$")

for ((i = 0; i < ${#LANGS_POSTFIX[@]}; i++)); do
    cd "$ETH" || exit 1
    LANG="${LANGS[i]}"
    POSTFIX="${LANGS_POSTFIX[i]}"
    # get num files and loc
    LOC=$(git ls-files | grep "$POSTFIX" | xargs wc -l | tail -n 1 | awk '{print $1}')
    NUM_FILES=$(git ls-files | grep -c "$POSTFIX")
    # write
    echo "$LANG. FILES: $NUM_FILES LOC: $LOC" >> "$OUT"
done

# write total files and loc
TOTAL_FILES=$(awk '{sum += $3} END {print "Total FILES:", sum}' "$OUT")
TOTAL_LOC=$(awk '{sum += $5} END {print "Total LOC:", sum}' "$OUT")
echo -e "\n$TOTAL_FILES" >> "$OUT"
echo "$TOTAL_LOC" >> "$OUT"


# todo: andel




