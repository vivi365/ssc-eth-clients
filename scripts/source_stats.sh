#!/bin/bash

DIR="ssc-eth-clients/data/repo"
ETH="$HOME/go-ethereum"
OUT="$HOME/$DIR/eth-langs.txt"
rm "$OUT"

LANGS=("Go" "C" "JavaScript" "Assembly" "Shell" "Java" "Sage" "M4" "NSIS" "Python" "Solidity" "Makefile" "HTML" "Dockerfile")
LANGS_POSTFIX=("\.go$" "\.[ch]$" "\.js$" "\.s$" "\.sh$" "\.java$" "\.sage$" "\.m4$" "\.ns[ih]$" "\.py$" "\.sol$" "Makefile$" "html$" "Dockerfile[.alltools]*$")

for ((i = 0; i < ${#LANGS_POSTFIX[@]}; i++)); do
    LANG="${LANGS[i]}"
    POSTFIX="${LANGS_POSTFIX[i]}"
    cd "$ETH" || exit 1
    git ls-files | grep "$POSTFIX" | xargs wc -l | tail -n 1 | awk -v lang="$LANG" '{print lang ": " $1 " (LOC)"}' >> "$OUT"
done

TOTAL=$(awk '{sum += $2} END {print "Total:", sum}' "$OUT")
echo "$TOTAL" >> "$OUT"
# todo: file count with wc -l and awk '{print $1 - 1}', exept if 0 then 1
# todo: total loc
# todo: andel




