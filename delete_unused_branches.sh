#!/bin/bash

REMOTE_URL=https://current_origin_url
REMOTE_URL_WITHOUT_HTTPS=current_origin_url

SVN_REMOTE_URL=https://svn_host_url

TOKEN='GITHUB/GITLAB_TOKEN'
USERNAME='git_username'
EMAIL='git_email'
# Path to the Git repository
LOCAL_REPO_PATH="$1"

# Function to handle errors
handle_error() {
    local exit_code=$?
    echo "Error occurred on line $1. Exiting." >&2
    exit $exit_code
}

# Trap errors and call the handle_error function
trap 'handle_error $LINENO' ERR

# Check if the path to the Git repository is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path-to-git-repo>"
    exit 1
fi

# Check if the repository exists
if [ ! -d "$LOCAL_REPO_PATH" ]; then
    echo "Error: Repository not found at '$LOCAL_REPO_PATH'"
    exit 1
fi

cd $LOCAL_REPO_PATH

echo Processing dir: $(pwd)



git config user.name "$USERNAME"
git config user.email $EMAIL

git remote set-url origin https://$USERNAME:$TOKEN@$REMOTE_URL_WITHOUT_HTTPS



# Get a list of remote branches excluding those from svn ls
branches_to_delete=$(git branch -r | grep -v -E "$(svn ls $SVN_REMOTE_URL | sed 's|/||g')" | awk -F/ '{print $2}' | sed 's/origin\///' | grep -v 'master' | grep -v 'moiz'  | grep -v 'main')
# branches_to_delete+=" master"

# Count the number of branches
branch_count=$(echo "$branches_to_delete" | wc -w)


echo '*++++++++++++++++++++++++++++++++++++++++*'
echo The following branches will be deleted. Total: $branch_count  
echo '*----------------------------------------*'
# Confirm branches to be deleted
echo "$branches_to_delete"
echo '*++++++++++++++++++++++++++++++++++++++++*'
read -p "Are you sure you want to delete these branches? (y/n): " confirm

if [ "$confirm" == "y" ]; then
    # Delete remote branches
    echo "$branches_to_delete" | xargs -I {} git push origin :{}
    echo "Branches deleted successfully."
else
    echo "Operation canceled by user."
fi

echo 'All set!'


# git branch | grep -v -E "$(svn ls $SVN_REMOTE_URL| sed 's|/||g')" | xargs -I {} git branch -D {}
# git branch | grep -v -E "$(svn ls $SVN_REMOTE_URL| sed 's|/||g')" | sed 's/origin\///' | xargs -I {} git push origin --delete {}
# Delete remote branches
# git branch -r | awk -F/ '//{print $2}' | xargs -I {} git push origin :{}