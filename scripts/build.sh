#!/bin/bash

set -e

# Grab the root directory path for redis-cluster-docker-swarm.
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
# Grab the version number from version.txt.
TAG=${1:-`cat ${ROOT}/VERSION`}

for image in "redis-look" "redis-sentinel" "redis-utils"; do
	echo "Building $image"
	docker build -t mlaradji/${image}:${TAG} "${ROOT}/${image}"
	docker push mlaradji/${image}:${TAG} &
done

wait