#!/usr/bin/bash

# Migration from SVN repo to Git with all history
# Author: Ahmed Khan <a.manzoor743@gmail.com>
# This script was created following this amazing article by Giovanni Zito
# https://www.linkedin.com/pulse/migrating-from-svn-git-8-steps-preserving-history-giovanni-zito/

set -e  # Exit immediately if any command exits with a non-zero status

# Source the configuration file
source config.sh

# Function to handle errors
handle_error() {
    local exit_code=$?
    echo "Error occurred on line $1. Exiting." >&2
    exit $exit_code
}

# Trap errors and call the handle_error function
trap 'handle_error $LINENO' ERR

# Check if the required variables are set
if [[ -z "$TARGET_DIR" || -z "$SVN_HOST" || -z "$AUTHORS_FILE" ]]; then
    echo "Error: Please set all required variables in config.sh"
    exit 1
fi


# Step 2. Initializing the git repository
if [ ! -d "$TARGET_DIR" ]; then
    mkdir "$TARGET_DIR"
fi

cd $TARGET_DIR

git svn init $SVN_HOST --stdlayout --no-metadata
# import users into the git repository you just created:
# Check if AUTHORS_FILE exists, and create if necessary
if [ ! -f "$AUTHORS_FILE" ]; then
    # You may want to replace the following line with the appropriate command
    # to create AUTHORS_FILE or provide the correct path if it's predefined.
    echo "Looks like you've not imported the svn users, import them in file $AUTHORS_FILE and try again."
    exit 1
fi

git config svn.authorsfile $AUTHORS_FILE

# Step 3. Import the repo from SVN
git svn fetch

echo These are imported branches:
git branch -a
# Step 4. Conversion of tags
for t in `git branch -a | grep 'tags/' | sed s_remotes/origin/tags/__` ; do
 git tag $t origin/tags/$t
 git branch -d -r origin/tags/$t
done

git tag -l

# Step 5. Converting branches
for t in `git branch -r | sed s_origin/__` ; do
 git branch $t origin/$t
 git branch -D -r origin/$t
done

# Step 6. Cleaning the SVN stuff
git config --remove-section svn-remote.svn
git config --remove-section svn
rm -fr .git/svn .git/{logs,}/refs/remotes/svn