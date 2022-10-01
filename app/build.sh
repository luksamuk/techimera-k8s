#!/bin/bash

VERSION=`awk '/:version/{print $2}' techimera.asd | tr -d '"'`
TAG="luksamuk/techimera:${VERSION}"

echo "Building $TAG..."
docker build -f Dockerfile -t $TAG .

