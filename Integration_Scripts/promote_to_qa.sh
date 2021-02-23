#!/bin/bash

#Author: DALQUINT - denny.alquinta@oracle.com
#Purpose: This script automates the promotion of repositories from feature to QA branch
#Copyright (c) 2020, Oracle and/or its affiliates. All rights reserved.

if [ "$#" -ne 1 ]; then
    echo "Missing feature branch! Usage: ./promote_to_qa.sh my_feature_branch"
else
    echo 'Checking out branch: '$1
    git checkout -b $1
    echo 'Pulling latest changes on branch: '$1
    git pull origin $1
    echo 'Setting upstream configuration'
    git branch --set-upstream-to=origin/$1 $1
    echo 'Checking out QA Branch'
    git checkout QA
    echo 'Pulling latest status of QA branch'
    git pull --ff-only
    echo 'Merging '$1 ' into QA branch'
    git merge $1 --no-ff
    echo 'Pushing changes to QA branch'
    git push
    echo 'Merge from '$1 'to successfully executed. Returning to '$1 'branch'
    git checkout $1
fi