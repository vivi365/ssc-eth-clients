#!/bin/bash

DIR="ssc-eth-clients/data/repo"
ETH="$HOME/go-ethereum"
OUT="$HOME/$DIR/eth-langs.txt"
rm "$OUT"

LANGS=("Go" "C" "JavaScript" "Assembly" "Shell" "Java" "Sage" "M4" "NSIS" "Python" "Solidity" "Makefile" "HTML" "Dockerfile")
LANGS_POSTFIX=("go" "c$|h" "js" "s" "sh" "java" "sage" "m4" "nsis" "py" "sol" "Makefile" "html" "Dockerfile")

for ((i = 0; i < ${#LANGS_POSTFIX[@]}; i++)); do
    LANG="${LANGS[i]}"
    POSTFIX="${LANGS_POSTFIX[i]}"
    cd "$ETH" || exit 1
    git ls-files | grep "\.$POSTFIX$" | xargs wc -l | grep "total$" | awk -v lang="$LANG" '{print lang ": " $1}' >> "$OUT"
done

# todo: total loc





