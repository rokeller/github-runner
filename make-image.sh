#!/bin/bash

BASE_PATH=$(dirname $0)
LATEST_VERSION=${1:-$($BASE_PATH/get-latest-release.sh)}
RUNNER_VERSION=$(echo -n $LATEST_VERSION | sed -E 's/^v(.+)$/\1/')
RUNNER_ARCHITECTURE=${RUNNER_ARCHITECTURE-x64}
IMAGE_NAME=github-runner

echo "Latest release of GitHub runner is $LATEST_VERSION"
echo "Building runner image for $RUNNER_VERSION / $RUNNER_ARCHITECTURE ..."

docker image build \
    --pull \
    --build-arg RUNNER_VERSION=$RUNNER_VERSION \
    --build-arg RUNNER_ARCHITECTURE=$RUNNER_ARCHITECTURE \
    --tag $IMAGE_NAME:$RUNNER_VERSION \
    $BASE_PATH
docker image tag $IMAGE_NAME:$RUNNER_VERSION $IMAGE_NAME:latest
