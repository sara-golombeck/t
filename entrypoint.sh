#!/bin/sh

# Use TN_SIZE from environment variable, default to 150 if not set
SIZE=${TN_SIZE:-150}

# Process all image files in /pics directory
for file in /pics/*; do
    if [ -f "$file" ]; then
        echo "Processing: $file with size: $SIZE"
        ./thumbnail.sh "$file" "$SIZE"
    fi
done