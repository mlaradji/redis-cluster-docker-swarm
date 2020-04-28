#!/bin/sh

set -e

# Grab the root directory path for redis-cluster-docker-swarm.
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
# Grab the version number from version.txt.
export TAG=`cat ${ROOT}/VERSION`

docker network create --attachable --driver overlay redis
docker stack deploy -c "${ROOT}/test/docker-compose.yml" cache
"${ROOT}"/scripts/./bootstrap.sh -o3 -r3
