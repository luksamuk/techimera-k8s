#!/bin/bash

VERSION=`awk '/:version/{print $2}' techimera.asd | tr -d '"'`
TAG="luksamuk/techimera:${VERSION}"

echo "Building $TAG..."
docker buildx build \
       -f Dockerfile \
       --platform="linux/amd64,linux/arm64" \
       -t $TAG \
       --push \
       .

