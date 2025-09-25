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
    # Look for the first meaningful line after ### Overview, skipping comments and empty lines
    awk '
        /^### Overview/ { found_overview = 1; next }
        found_overview && /^<!--/ { next }
        found_overview && /^$/ { next }
        found_overview && /^###/ { exit }
        found_overview && NF > 0 { print; exit }
    ' "$file" | sed 's/^[[:space:]]*//'
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
    
    # Extract overview description from backup file
    description=$(extract_overview "$file.bak")
    if [[ -z "$description" ]]; then
        description="KRM function for $function_name"  # fallback
    fi
    
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
    
    # Append the original content (everything from backup)
    cat "$file.bak" >> "$file.tmp"
    
    # Replace original file
    mv "$file.tmp" "$file"
    
    echo "Updated: $file (function: $function_name, tags: $tags, desc: $description)"
done

echo "All _index.md files have been updated with standardized front matter"