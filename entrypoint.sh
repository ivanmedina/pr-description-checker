#!/bin/bash

set -e

DIR=$(dirname "$0")
source "${DIR}/requesters.sh"

if [[ -z "$GITHUB_REPOSITORY" ]]; then
    echo "The env variable GITHUB_REPOSITORY is required"
    exit 1
fi

if [[ -z "$GITHUB_EVENT_PATH" ]]; then
    echo "The env variable GITHUB_EVENT_PATH is required"
    exit 1
fi

if [[ -z "$GITHUB_EVENT_NAME" ]]; then
  echo "Set the GITHUB_EVENT_NAME env variable."
  exit 1
fi

GITHUB_TOKEN=$1
regex=$2
SUCCESS_EMOJI=$3
SUCCESS_COMMENT=$4
FAIL_EMOJI=$5
FAIL_COMMENT=$6

echo "regex: $regex"
echo "SUCCESS_EMOJI: $SUCCESS_EMOJI"
echo "SUCCESS_COMMENT: $SUCCESS_COMMENT"
echo "FAIL_EMOJI: $FAIL_EMOJI"
echo "FAIL_COMMENT: $FAIL_COMMENT"

# @param - description
# @param - regex

match()
{
	if [[ $2 =~ $(echo $1) ]];then
		return 1
	fi

	return 0
}

success()
{
	if [[ -n "$SUCCESS_EMOJI" ]]; then
    	sendReaction "$number" "$SUCCESS_EMOJI"
    	echo "Success reaction sent"
  	fi

	if [[ -n "$SUCCESS_COMMENT" ]]; then
    	sendComment "$number" "$SUCCESS_COMMENT"
    	echo "Success comment sent"
  	fi
}

fail()
{
	if [[ -n "$FAIL_EMOJI" ]]; then
		sendReaction "$number" "$FAIL_EMOJI"
		echo "Failure reaction sent"
	fi

	if [[ -n "$FAIL_COMMENT" ]]; then
		sendComment "$number" "$FAIL_COMMENT"
		echo "Failure comment sent"
	fi
}

URI="https://api.github.com"
API_HEADER="Accept: application/vnd.github.v3+json"
AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
number=$( jq --raw-output .pull_request.number "$GITHUB_EVENT_PATH" )
GITHUB_PULL_REQUEST_EVENT_BODY=$(jq --raw-output .pull_request.body "$GITHUB_EVENT_PATH")

if [[ "$GITHUB_EVENT_NAME" != "pull_request" ]]; then
	echo "The github event name is not pull_request"
	exit 1
fi 

matched=match "$(echo $regex)" "$GITHUB_PULL_REQUEST_EVENT_BODY"

if [[ $matched -ne 0 ]]; then
	echo "The github description does not match pattern"
	echo "$regex"
	fail
	exit 1
fi

success
exit 0
