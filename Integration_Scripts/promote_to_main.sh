#!/bin/bash

#Author: DALQUINT - denny.alquinta@oracle.com
#Purpose: This script automates the promotion of repositories from feature to master branch
#Copyright (c) 2020, Oracle and/or its affiliates. All rights reserved.

if [ "$#" -ne 0 ]; then
    echo "No arguments are required. Usage: ./promote_to_main.sh"
else
    echo 'Checking out branch QA'
    git checkout QA
    echo 'Pulling latest changes on branch: QA'
    git pull origin QA
    echo 'Setting upstream configuration'
    git branch --set-upstream-to=origin/QA QA
    echo 'Checking out master Branch'
    git checkout master
    echo 'Pulling latest status of master branch'
    git pull --ff-only
    echo 'Merging QA  into master branch'
    git merge QA --no-ff
    echo 'Pushing changes to master branch'
    git push
    echo 'Merge from QA to master successfully executed. Staying in master branch'
fi
