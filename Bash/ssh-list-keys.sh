#!/usr/bin/env bash

# Directory to scan (default to current directory if not provided)
DIR="${1:-.}"

# Check if directory exists
if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' does not exist."
    exit 1
fi

# Function to get the base name without extension
get_basename() {
    local file="$1"
    # Remove path and get just filename
    local filename=$(basename "$file")
    # Remove extension (everything after the last dot)
#    echo "${filename%.*}"
    echo "${filename}"
}

echo "[+] Scanning directory: $DIR"
echo "----"

INDEX=0
declare -a basenames
declare -a ordered

# Collect all files and their base names
for FILE in "$DIR"/*; do
    # Skip if not a regular file
    [ -f "$FILE" ] || continue

    basename_file=$(get_basename "$FILE")

    if [[ "${basename_file}" == known_hosts* ]] || [ "${basename_file}" = "config" ] || [[ "${basename_file}" == authorized_keys* ]]; then
        continue
    fi

    basenames[ $INDEX ]="$basename_file"
    (( INDEX++ ))
done

ordered=(`for EACH in "${basenames[@]}"; do echo "${EACH%.*}"; done | sort -du`)

for EACH in "${ordered[@]}"; do
    echo "$EACH:"
    ssh-keygen -lf "$DIR/$EACH" -E sha256
    echo
done
