#!/bin/sh

DIR="ssc-eth-clients/data/repo"
curl -o "$HOME/$DIR/eth-langs-raw.json" https://api.github.com/repos/ethereum/go-ethereum/languages

# todo api via js