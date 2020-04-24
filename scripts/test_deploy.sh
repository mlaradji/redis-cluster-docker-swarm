#!/bin/sh

set -e

# Grab the root directory path for redis-cluster-docker-swarm.
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"
# Grab the version number from version.txt.
export TAG=`cat ${ROOT}/VERSION`

docker network create --attachable --driver overlay redis --subnet 172.18.0.0/16
docker stack deploy -c "$ROOT/scripts/docker-compose.yml" cache
"$ROOT"/scripts/./bootstrap.sh
