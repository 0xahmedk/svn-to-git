#!/usr/bin/bash

SVN_HOST='https://mysvnhost/mypath/mysvnreponame'
TARGET_DIR='/home/myuser/mygitrepo'
AUTHORS_FILE='/home/myuser/svn-authors.txt'


# Step 1. Export svn users
# svn log $SVN_HOST --quiet | grep -E "r[0-9]+ \| .+ \|" | cut -d'|' -f2 | sed 's/ //g' | sort | uniq > /home/myuser/svn-authors.txt
# Step 2. Initializing the git repository
mkdir $TARGET_DIR
cd $TARGET_DIR
git svn init $SVN_HOST --stdlayout --no-metadata
# import users into the git repository you just created:
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