#!/bin/bash

# Check if the HUGO_BLOG_CONTENT environment variable is set
if [ -z "$HUGO_BLOG_CONTENT" ]; then
  echo "Error: HUGO_BLOG_CONTENT environment variable is not set."
  exit 1
fi

# Get the current date in the yyyy/mm/dd format
current_date=$(date +'%Y/%m/%d')

# Define the full path for the new Hugo blog post
file_name="$1"
file_path="$HUGO_BLOG_CONTENT/$current_date/$file_name.md"

# Check if the file already exists
if [ -e "$file_path" ]; then
  echo "Error: A blog post with the same name already exists."
  exit 1
fi

# Create the directory structure if it doesn't exist
mkdir -p "$(dirname "$file_path")"

# Titleize the filename for the "title" field
titleized_title=$(echo "$file_name" | sed -e 's/-/ /g' -e 's/\b\(.\)/\u\1/g')

# Create and open the new blog post in Vim
echo "---" > "$file_path"
echo "title: \"$titleized_title\"" >> "$file_path"
echo "date: $(date --iso-8601=seconds)" >> "$file_path"
echo "---" >> "$file_path"

# Open the new blog post in Vim
vim "$file_path"

echo "New Hugo blog post created at: $file_path"

