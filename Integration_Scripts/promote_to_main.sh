#!/bin/bash

#Author: DALQUINT - denny.alquinta@oracle.com
#Purpose: This script automates the promotion of repositories from feature to main branch
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
    echo 'Checking out main Branch'
    git checkout main
    echo 'Pulling latest status of main branch'
    git pull --ff-only
    echo 'Merging QA  into main branch'
    git merge QA --no-ff
    echo 'Pushing changes to main branch'
    git push
    echo 'Merge from QA to main successfully executed. Staying in main branch'
fi
