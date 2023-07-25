#!/bin/bash

# Function to extract nested value from JSON object
get_nested_value() {
    local json="$1"
    local key="$2"
    echo "$json" | jq -r ".$key"
}

# Main script
input_json="$1"
key="$2"

# Convert slashes (/) to dots (.) in the key
key=$(echo "$key" | tr '/' '.')

output=$(get_nested_value "$input_json" "$key")

echo "Input: $input_json, Key: $key, Output: $output"

