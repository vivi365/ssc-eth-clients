#!/bin/bash

# TODO this is hard coded, redundant and ugly :-(
SRC_DIR=~/go-ethereum
OUT=~/ssc-eth-clients/data/dependencies/reports
# TODO checkout correct commit

# handles from go.mod, processed ~~manually~~
CORE_DEVS=("cespare" "fjl" "gballet" "holiman" "karalabe" )
INDIVIDUALS=("/natefinch" "github.com/davecgh" "github.com/deckarep" "github.com/dop251" "github.com/fatih" 
"github.com/ferranbt" "github.com/huin" "github.com/jackpal" "github.com/jedisct1" "github.com/julienschmidt" 
"github.com/kylelemons" "github.com/mattn" "github.com/naoina" "github.com/olekukonko" "github.com/peterh" "github.com/protolambda" 
"github.com/rs/" "github.com/shirou/" "github.com/syndtr/" "github.com/tyler-smith/" "github.com/beorn7/" "github.com/bits-and-blooms/" 
"github.com/cpuguy83" "github.com/dlclark/" "github.com/garslo/" "github.com/go-sourcemap/" "github.com/goccy/" "github.com/kilic/" "github.com/klauspost/" 
"github.com/kr/" "github.com/matttproud/" "github.com/mitchellh/" "github.com/mmcloughlin" "github.com/pmezard/" "github.com/rivo/" "github.com/rogpeppe/" 
"github.com/russross/" "github.com/tklauser" "github.com/xrash/" "rsc.io/")
ORG_OR_COMMUNITY=("Azure" "Microsoft" "VictoriaMetrics" "aws" "btcsuite" "cloudflare" 
"cockroachdb" "consensys" "crate-crypto" "ethereum/c-kzg-4844" "fsnotify" "gofrs" "golang-jwt/"
"gorilla" "graph-gophers" "hashicorp" "influxdata" "status-im"
"stretchr" "supranational" "urfave" "github.com/golang/" "github.com/google/" "go.uber.org" "golang.org" "gopkg.in/yaml"
"DataDog" "StackExchange" "decred" "deepmap" "go-ole" "gogo" "jmespath" "minio"
"opentracing" "github.com/pkg/" "prometheus")


# CORE_DEVS
POSTFIX=dependencies_core_devs.txt
rm $OUT/$POSTFIX
for i in "${CORE_DEVS[@]}"; 
do  
    grep "$i" < $SRC_DIR/go.mod >> $OUT/$POSTFIX
done
NUM_DEPENDENCIES=$(wc -l < $OUT/$POSTFIX)
echo -e "\nTotal owners: ${#CORE_DEVS[@]}" >> $OUT/$POSTFIX
echo "Total dependencies: $NUM_DEPENDENCIES" >> $OUT/$POSTFIX
NUM_IND=$(cat $OUT/$POSTFIX | grep -c '// indirect')
echo "Total indirect: $NUM_IND" >> $OUT/$POSTFIX


# INDIVIDUALS
POSTFIX=dependencies_individuals.txt
rm $OUT/$POSTFIX
for i in "${INDIVIDUALS[@]}"; 
do  
    grep "$i" < $SRC_DIR/go.mod >> $OUT/$POSTFIX
done
NUM_DEPENDENCIES=$(wc -l < $OUT/$POSTFIX)
echo -e "\nTotal owners: ${#INDIVIDUALS[@]}" >> $OUT/$POSTFIX
echo "Total dependencies: $NUM_DEPENDENCIES" >> $OUT/$POSTFIX
NUM_IND=$(cat $OUT/$POSTFIX | grep -c  '// indirect')
echo "Total indirect: $NUM_IND" >> $OUT/$POSTFIX


# ORG_OR_COMMUNITY
POSTFIX=dependencies_organisations.txt
rm $OUT/$POSTFIX
for i in "${ORG_OR_COMMUNITY[@]}"; 
do  
    grep "$i" < $SRC_DIR/go.mod >> $OUT/$POSTFIX
done
NUM_DEPENDENCIES=$(wc -l < $OUT/$POSTFIX)
echo -e "\nTotal owners: ${#ORG_OR_COMMUNITY[@]}" >> $OUT/$POSTFIX
echo "Total dependencies: $NUM_DEPENDENCIES" >> "$OUT/$POSTFIX"
NUM_IND=$(cat $OUT/$POSTFIX | grep -c '// indirect')
echo "Total indirect: $NUM_IND" >> $OUT/$POSTFIX

echo -e "\n --- organizations ---"
for o in "${ORG_OR_COMMUNITY[@]}"; 
do
    # dummy 
    D=$(cat ./data/dependencies/reports/dependencies_organisations.txt | grep -Ewi $o)
    D1=$(echo "$D" | wc -l)
    D2=$(echo "$D" | grep -c 'indirect')
    echo -e "$o dependencies: $D1 Indirect: $D2"
done

# cat ./data/dependencies/reports/dependencies_organisations.txt | grep -Ewi -c 'golang.org|go.uber|google|golang|gopkg.in' 

echo -e "\n --- individuals ---"
for o in "${INDIVIDUALS[@]}"; 
do
    # dummy 
    D=$(cat ./data/dependencies/reports/dependencies_individuals.txt | grep -Ewi $o)
    D1=$(echo "$D" | wc -l)
    D2=$(echo "$D" | grep -c 'indirect')
    echo -e "$o dependencies: $D1 Indirect: $D2"
done
