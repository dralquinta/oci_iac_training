#!/bin/bash -e
#Author: JSALAMAN - juan.salamanca@oracle.com
#Purpose: This script automates the promotion of repositories from feature to QA branch
#Copyright (c) 2020, Oracle and/or its affiliates. All rights reserved.

if [ "$#" -ne 2 ]; then
    echo "Missing version or comments arguments! Usage: ./generate_tag.sh 'tag_version' 'comments'"
else
    echo "Moving to master branch "
    git checkout master

    echo "Tagging code for production release"
    git tag -a $1 -m "$2"

    echo "Pushing tag to master branch"
    git push origin $1
fi