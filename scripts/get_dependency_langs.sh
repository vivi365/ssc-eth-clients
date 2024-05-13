#!/bin/bash


if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <filename to read> <api token>"
    exit 1
fi


IN_FILE=$1
TOKEN=$2

DIR=$HOME/ssc-eth-clients/data/dependencies/reports
TMP=$DIR/tmp.txt
QUERYABLE=$DIR/cleaned_repo_names.txt
LANGS=$DIR/geth_dependencies_languges.txt
touch "$LANGS" "$TMP"
rm "$QUERYABLE" "$LANGS" "$TMP"


# get dependencies 
awk -F ' ' '{print $1}' "$DIR/$IN_FILE" > "$TMP"
cut -d'/' -f2- "$TMP" > "$QUERYABLE"

# query langs
while read -r p || [ -n "$p" ]; do
    RESP=$(curl -s "https://api.codetabs.com/v1/loc/?github=${p}")
    NOT_FOUND=$(echo ${RESP} | jq '.Error == "Not Found"')


    #RESP=$(curl -s "https://api.github.com/repos/${p}/languages" -H "Authorization: Bearer $TOKEN")
    #NOT_FOUND=$(echo ${RESP} | jq '.message == "Not Found"')
    if [[ $NOT_FOUND == "true" ]]; then
        echo -e "\n\nRepository ' $p ' Not found on GitHub." >> "$LANGS"
    else
        echo -e "\n\nRepository: $p \n $RESP" >> "$LANGS"
    fi 
       #if [] >> "$LANGS"
done < "${QUERYABLE}"


rm "$QUERYABLE" "$TMP"