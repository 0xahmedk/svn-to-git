#!/usr/bin/bash

# Source the configuration file
source config.sh

svn log $SVN_HOST --quiet | 
grep -E "r[0-9]+ \| .+ \|" | 
cut -d'|' -f2 | 
sed 's/ //g' | 
sort | 
uniq > $AUTHORS_FILE

# Function to format an author
format_author() {
    local username="$1"
    echo "$username = $username <${username}@gmail.com>"
}

# Check if the input file exists
if [ ! -f "$AUTHORS_FILE" ]; then
    echo "Error: File $AUTHORS_FILE not found."
    exit 1
fi

# Format authors and update the file in place
while IFS= read -r username; do
    formatted_author=$(format_author "$username")
    # Use sed to find and replace the original line with the formatted line
    sed -i "s/^$username.*/$formatted_author/" "$AUTHORS_FILE"
done < "$AUTHORS_FILE"

echo "Formatting completed. $AUTHORS_FILE updated with formatted authors."

echo Authors have been imported successfully into the $AUTHORS_FILE. Update them as required and run import-svn-repo.sh script