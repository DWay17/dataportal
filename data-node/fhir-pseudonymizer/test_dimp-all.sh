#!/bin/bash
#grep -Ei 'hash.?key' *.env .env dimp_dup_*.yaml > 
function test_dimp(){
  FILE="$1"
  FILENAME=$(basename "$FILE")
	echo "FILENAME $FILENAME"
	DIRNAME=$(dirname "$FILE")
	echo "DIRNAME $DIRNAME"
	EXT="${FILENAME##*.}"
	echo "EXT $EXT"
	BASENAME=$(basename -s "."$EXT "$FILENAME")
	echo "BASENAME $BASENAME"
  # -v --backup=numbered
  FILE_NEW=$(echo "$FILE" | sed -Ee 's#\bin\b#out#g')
  echo "FILE_NEW $FILE_NEW"
  mv -v --backup=numbered "$FILE_NEW" "$FILE_NEW~"
  return
  curl --request POST \
    --url 'http://localhost:8083/fhir/$de-identify' \
    --header 'content-type: application/json' \
    --data @"$FILE" \
    | jq . >> "$FILE_NEW"
  chown -c trichter:trichter "$FILE_NEW"
}


# Prüfen, ob Dateien als Parameter übergeben wurden
if [[ $# -gt 0 ]]; then
    for file in "$@"; do
        if [[ -f "$file" ]]; then
            test_dimp "$file"
        else
            echo "Datei nicht gefunden: $file"
        fi
    done
else
    echo "Suche json aktuellen Verzeichnis..."
    for file in $(find . -maxdepth 1 -iname '*test*dimp*in*.json' | grep -v 'tmp' ) ; do
        if [[ -f "$file" ]]; then
            test_dimp "$file"
        else
            echo "Datei nicht gefunden: $file"
        fi
    done
fi



