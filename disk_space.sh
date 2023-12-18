#!/bin/bash

# Function to process disk space information
process_disk_space() {
    local filesystem=$1
    local usage_percentage=$2

    # Add your disk space processing logic here
    echo "Filesystem: $filesystem, Usage: $usage_percentage"
}

# Create a temporary file to store the output of df -h
temp_file=$(mktemp)
df -h > "$temp_file"

# Main script
while IFS= read -r line; do
    # Skip the header line (assuming the first line is a header)
    if [[ "$line" == Filesystem* ]]; then
        continue
    fi

    # Extract filesystem and usage percentage from the line
    filesystem=$(echo "$line" | awk '{print $1}')
    usage_percentage=$(echo "$line" | awk '{print $5}' | cut -d'%' -f1)

    # Process disk space information
    process_disk_space "$filesystem" "$usage_percentage"
done < "$temp_file"

# Remove the temporary file
rm "$temp_file"
