#!/bin/sh

# Inspired by:
# https://github.com/transferwise/actions-pr-checker/blob/master/functions.sh 

# Send emoji to PR description
# @param - GITHUB_PULL_REQUEST_EVENT_NUMBER
# @param - EMOJI
sendReaction() 
{
    local GITHUB_ISSUE_NUMBER="$1"
    local EMOJI="$2"

    curl -sSL \
         -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.squirrel-girl-preview+json" \
         -X POST \
         -H "Content-Type: application/json" \
         -d "{\"content\":\"${EMOJI}\"}" \
            "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${GITHUB_ISSUE_NUMBER}/reactions"
}

# Send comment to PR
# @param - GITHUB_PULL_REQUEST_EVENT_NUMBER
# @param - comment text
sendComment() 
{
    local GITHUB_ISSUE_NUMBER="$1"
    local GITHUB_ISSUE_COMMENT="$2"

    jq -n --arg msg "$GITHUB_ISSUE_COMMENT" '{body: $msg }' > tmp.txt

    curl -sSL \
         -H "Authorization: token ${GITHUB_TOKEN}" \
         -H "Accept: application/vnd.github.v3+json" \
         -X POST \
         -H "Content-Type: application/json" \
         -d @tmp.txt \
            "https://api.github.com/repos/${GITHUB_REPOSITORY}/issues/${GITHUB_ISSUE_NUMBER}/comments"
}