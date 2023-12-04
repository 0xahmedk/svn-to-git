#!/bin/bash

export FILTER_BRANCH_SQUELCH_WARNING=1 # This will suppress the warning shown by git

git filter-branch -f --env-filter '
    if test "$GIT_AUTHOR_EMAIL" = "your_email"
    then
        GIT_AUTHOR_EMAIL=new_email
    fi
    if test "$GIT_COMMITTER_EMAIL" = "your_email"
    then
        GIT_COMMITTER_EMAIL=new_email
    fi
' HEAD