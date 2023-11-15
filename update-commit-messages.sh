#!/bin/bash

# Check if the path to the Git repository is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path-to-git-repo>"
    exit 1
fi

# Path to the Git repository
REPO_PATH="$1"

# Check if the repository exists
if [ ! -d "$REPO_PATH" ]; then
    echo "Error: Repository not found at '$REPO_PATH'"
    exit 1
fi

# Define the pattern to replace in commit messages
PATTERN="###"
REPLACEMENT="#"

# Run git filter-repo to replace the pattern in commit messages
git -C "$REPO_PATH" filter-repo --force --message-callback "
    if b'$PATTERN' in message:
        message = message.replace(b'$PATTERN', b'$REPLACEMENT')
    return message
"