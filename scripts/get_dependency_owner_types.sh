#!/bin/bash

# Check for required commands
jq_cmd=$(command -v jq)
if [ -z "$jq_cmd" ]; then
    echo "jq is required but not installed. Please install jq."
    exit 1
fi

# Check for correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <owners_file.json> <src_dir> <out_dir>"
    exit 1
fi

# Load arguments
DEP_OWNERS_FILE=$1
SRC_DIR=$2
OUT=$3

# Load dependency owners from JSON file
CORE_DEVS=($(jq -r '.CORE_DEVS[]' $DEP_OWNERS_FILE))
INDIVIDUALS=($(jq -r '.INDIVIDUALS[]' $DEP_OWNERS_FILE))
ORG_OR_COMMUNITY=($(jq -r '.ORG_OR_COMMUNITY[]' $DEP_OWNERS_FILE))

# Function to process dependencies
# This works as the github username is the same as the basename of the package
process_dependencies() {
    local owners=("$@")
    local postfix=$1.txt
    rm $OUT/$postfix
    for i in "${owners[@]}"; do  
        grep "$i" < $SRC_DIR/go.mod >> $OUT/$postfix
    done
    NUM_DEPENDENCIES=$(wc -l < $OUT/$postfix)
    echo -e "\nTotal owners: ${#owners[@]}" >> $OUT/$postfix
    echo "Total dependencies: $NUM_DEPENDENCIES" >> $OUT/$postfix
    NUM_IND=$(grep -c '// indirect' $OUT/$postfix)
    echo "Total indirect: $NUM_IND" >> $OUT/$postfix
}

# Process each category
process_dependencies "${CORE_DEVS[@]}"
process_dependencies "${INDIVIDUALS[@]}"
process_dependencies "${ORG_OR_COMMUNITY[@]}"

# Function to display dependency counts
display_dependency_counts() {
    local owners=("$@")
    echo -e "\n --- ${1} ---"
    for o in "${owners[@]}"; do
        D=$(grep -Ewi $o $OUT/dependencies_$1.txt)
        D1=$(echo "$D" | wc -l)
        D2=$(echo "$D" | grep -c 'indirect')
        echo -e "$o dependencies: $D1 Indirect: $D2"
    done
}

# Display counts for each category
display_dependency_counts "organisations" "${ORG_OR_COMMUNITY[@]}"
display_dependency_counts "individuals" "${INDIVIDUALS[@]}"
