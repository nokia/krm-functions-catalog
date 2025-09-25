#!/bin/bash

# Function to tag mapping based on https://catalog.kpt.dev/
declare -A FUNCTION_TAGS
FUNCTION_TAGS["apply-replacements"]="mutator"
FUNCTION_TAGS["apply-setters"]="mutator"
FUNCTION_TAGS["create-setters"]="mutator"
FUNCTION_TAGS["enable-gcp-services"]="generator, mutator"
FUNCTION_TAGS["ensure-name-substring"]="mutator, name prefix, name suffix"
FUNCTION_TAGS["export-terraform"]="mutator, terraform"
FUNCTION_TAGS["fix"]="mutator"
FUNCTION_TAGS["gatekeeper"]="validator"
FUNCTION_TAGS["generate-folders"]="generator, mutator"
FUNCTION_TAGS["kubeval"]="validator"
FUNCTION_TAGS["list-setters"]="viewer"
FUNCTION_TAGS["remove-local-config-resources"]="config sync, mutator"
FUNCTION_TAGS["render-helm-chart"]="mutator"
FUNCTION_TAGS["search-replace"]="mutator"
FUNCTION_TAGS["set-annotations"]="mutator"
FUNCTION_TAGS["set-enforcement-action"]="config sync, mutator"
FUNCTION_TAGS["set-image"]="mutator"
FUNCTION_TAGS["set-labels"]="mutator"
FUNCTION_TAGS["set-namespace"]="mutator"
FUNCTION_TAGS["set-project-id"]="mutator"
FUNCTION_TAGS["starlark"]="mutator, validator"
FUNCTION_TAGS["upsert-resource"]="mutator"

# Function to extract overview content from a file
extract_overview() {
    local file="$1"
    # Extract content between ### Overview and next ### or end of file
    awk '/^### Overview/, /^###/ {
        if ($0 ~ /^###/ && NR > start_line + 1) exit
        if ($0 ~ /^### Overview/) { start_line = NR; next }
        if ($0 ~ /^<!--mdtogo:Short-->/) next
        if ($0 ~ /^<!--mdtogo-->/) next
        if ($0 ~ /^$/) next
        print
    }' "$file" | sed 's/^[[:space:]]*//' | head -1
}

# Process each _index.md file
find . -name "_index.md" | grep -E "/v[0-9]+\.[0-9]+/_index\.md$" | while read -r file; do
    echo "Processing: $file"
    
    # Extract function name from path (parent directory of version directory)
    function_name=$(echo "$file" | sed -E 's|^\./([^/]+)/v[0-9]+\.[0-9]+/_index\.md$|\1|')
    
    # Get tags for this function
    tags="${FUNCTION_TAGS[$function_name]}"
    if [[ -z "$tags" ]]; then
        tags="mutator"  # default fallback
    fi
    
    # Extract overview description
    description=$(extract_overview "$file")
    if [[ -z "$description" ]]; then
        description="KRM function for $function_name"  # fallback
    fi
    
    # Create backup
    cp "$file" "$file.bak"
    
    # Create new front matter
    cat > "$file.tmp" << EOF
---
title: "$function_name"
linkTitle: "$function_name"
tags: "$tags"
weight: 4
description: |
   $description
menu:
  main:
    parent: "Function Catalog"
---

EOF
    
    # Append the rest of the file (skip existing front matter if present)
    if grep -q "^---$" "$file.bak"; then
        # File has front matter, skip it
        awk '/^---$/ {count++; if(count==2) {skip=0; next} if(count==1) skip=1; next} !skip' "$file.bak" >> "$file.tmp"
    else
        # No front matter, append everything
        cat "$file.bak" >> "$file.tmp"
    fi
    
    # Replace original file
    mv "$file.tmp" "$file"
    
    echo "Updated: $file (function: $function_name, tags: $tags)"
done

echo "All _index.md files have been updated with standardized front matter"