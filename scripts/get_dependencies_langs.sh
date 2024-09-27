#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <input file> <output directory>"
    exit 1
}

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    usage
fi

# Load arguments
IN_FILE=$1
OUTPUT_DIR=$2

# Define files
TMP_FILE="$OUTPUT_DIR/tmp.txt"
QUERYABLE_FILE="$OUTPUT_DIR/cleaned_repo_names.txt"
LANGS_FILE="$OUTPUT_DIR/geth_dependencies_languages.txt"

# Ensure files are clean before starting
rm -f "$QUERYABLE_FILE" "$LANGS_FILE" "$TMP_FILE"

# Extract dependencies
awk -F ' ' '{print $1}' "$IN_FILE" > "$TMP_FILE"
cut -d'/' -f2- "$TMP_FILE" > "$QUERYABLE_FILE"

# Query languages
while read -r p || [ -n "$p" ]; do
    RESP=$(curl -s "https://api.codetabs.com/v1/loc/?github=${p}")
    NOT_FOUND=$(echo ${RESP} | jq '.Error == "Not Found"')
    
    if [[ $NOT_FOUND == "true" ]]; then
        echo -e "\n\nRepository ' $p ' Not found on GitHub." >> "$LANGS_FILE"
    else
        echo -e "\n\nRepository: $p \n $RESP" >> "$LANGS_FILE"
    fi
done < "${QUERYABLE_FILE}"

# Clean up temporary files
rm -f "$QUERYABLE_FILE" "$TMP_FILE"