#!/bin/bash -e
#Author: DALQUINT - denny.alquinta@oracle.com
#Purpose: This script automates the removal of a previously created tag
#Copyright (c) 2021, Oracle and/or its affiliates. All rights reserved.

if [ "$#" -ne 1 ]; then
    echo "Missing tag version argument! Usage: ./remove_tag.sh tag_version"
else
    echo "Moving to master branch "
    git checkout master

    echo "Removing local tag"
    git tag -d $1

    echo "Removing remote tag"
    git push --delete origin $1
fi