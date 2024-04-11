#!/bin/bash

SRC_DIR=~/go-ethereum
cd $SRC_DIR || exit 1
OUT=~/ssc-eth-clients/data/dependencies/graphs
mkdir -p $OUT

# list purpose of each package in geth
#go list -f '{{.Name}}: {{.Doc}}' all

# graph of packages in /cmd 
goda graph -cluster -short "./cmd/..." | dot -Tpng -o $OUT/cmd-packages-graph.png

# direct dependencies
goda graph -cluster -short "./...:import" | dot -Tpng -o $OUT/direct-dependencies-graph.png
# all dependencies
goda graph -cluster -short "./...:import:all" | dot -Tpng -o $OUT/all-dependencies-graph.png

# all dependencies in cmd/geth
goda graph -cluster -short "./cmd/geth...:import:all" | dot -Tpng -o $OUT/cmd-geth-all-dependencies.png
# all dependencies in cmd/evm
goda graph -cluster -short "./cmd/evm...:import:all" | dot -Tpng -o $OUT/cmd-evm-all-dependencies.png

# direct and indirect dependencies reaching gnark-crypto-ecc
goda graph -cluster -short "reach(./...:import:all, github.com/consensys/gnark-crypto/ecc/)" | dot -Tpng -o $OUT/direct-indirect-deps-gnark-ecc.png
goda graph -cluster -short "reach(./...:import:all, github.com/consensys/gnark-crypto/ecc/)" | dot -Tsvg -o $OUT/direct-indirect-deps-gnark-ecc.svg


# todo: prefer godepgraph
godepgraph -s github.com/ethereum/go-ethereum | dot -Tpng -o godepgraph.png  
godepgraph -s github.com/ethereum/go-ethereum/cmd/geth | dot -Tpng -o godepgraph.png


# analyse /crate-cryptogo-kzg-4844 dependencies
#cd ~/go-kzg-4844 || exit 1
#goda graph "./...:import:all" | dot -Tpng -o $OUT/crate-crypto-kzg-all-dependencies.png
#goda graph "./...:import" | dot -Tpng -o $OUT/crate-crypto-kzg-direct-dependencies.png

