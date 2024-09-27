#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <repo_directory> <output_directory>"
    exit 1
}

if [ "$#" -ne 2 ]; then
    usage
fi

ETH="$1"
OUT_DIR="$2"

# Create output directory if it doesn't exist
mkdir -p "$OUT_DIR"

# Generate output file name with date
DATE=$(date +"%Y-%m-%d")
OUT="$OUT_DIR/source_stats_$DATE.md"

rm -f "$OUT"

# Geth programming languages and their file extensions.
LANGS=("Go" "C" "JavaScript" "Assembly" "Shell" "Java" "Sage" "M4" "NSIS" "Python" "Solidity" "Makefile" "HTML" "Dockerfile")
LANGS_POSTFIX=("\.go$" "\.[ch]$" "\.js$" "\.s$" "\.sh$" "\.java$" "\.sage$" "\.m4$" "\.ns[ih]$" "\.py$" "\.sol$" "Makefile$" "html$" "Dockerfile[.alltools]*$")

# Change to the Ethereum directory
cd "$ETH" || { echo "Directory $ETH not found"; exit 1; }

TOTAL_FILES=0
TOTAL_LOC=0

# Write header to output file
{
    echo "# Source Code Statistics"
    echo "## Repository: $ETH"
    echo "## Date: $(date)"
    echo ""
} >> "$OUT"

# Loop through languages and count files and lines of code
for ((i = 0; i < ${#LANGS[@]}; i++)); do
    LANG="${LANGS[i]}"
    POSTFIX="${LANGS_POSTFIX[i]}"
    
    # Count lines of code and number of files
    LOC=$(git ls-files | grep -E "$POSTFIX" | xargs wc -l | tail -n 1 | awk '{print $1}')
    NUM_FILES=$(git ls-files | grep -Ec "$POSTFIX")
    
    # Write results to output file in Markdown format
    {
        echo "### $LANG"
        echo "- Files: $NUM_FILES"
        echo "- Lines of Code: $LOC"
    } >> "$OUT"
    
    # Update total counters
    TOTAL_FILES=$((TOTAL_FILES + NUM_FILES))
    TOTAL_LOC=$((TOTAL_LOC + LOC))
done

# Write total files and lines of code to output file
{
    echo "## Total Statistics"
    echo "- Total Files: $TOTAL_FILES"
    echo "- Total Lines of Code: $TOTAL_LOC"
} >> "$OUT"

echo "Source code statistics have been saved to $OUT"

