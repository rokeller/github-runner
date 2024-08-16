#!/bin/bash

ENV_FILE=$(dirname $0)/.env
if [ -f $ENV_FILE ]; then
    echo "Found .env file: $ENV_FILE"
    set -a
    . $ENV_FILE
    set +a
fi

if [ -z $GH_TOKEN ]; then
    echo 'The GH_TOKEN environment variable is not set. The runner wouldn'\''t connect.'
    exit 1
elif [ -z $GH_OWNER ]; then
    echo 'The GH_OWNER environment variable is not set. The runner wouldn'\''t connect.'
    exit 1
fi

GH_REPO=$1
if [ -z $GH_REPO ]; then
    echo 'The name of the repository to add the runner to is missing.'
    exit 2
fi
IMAGE_NAME=github-runner

docker container run \
    -e GH_TOKEN=$GH_TOKEN \
    -e GH_OWNER=$GH_OWNER \
    -e GH_REPOSITORY=$GH_REPO \
    --rm -it $IMAGE_NAME
