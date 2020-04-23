#!/bin/bash

set -e

export TAG="latest"
NUM_OF_SENTINELS=3
NUM_OF_REDIS=3
REDIS_SENTINEL_NAME="redis-sentinel"
REDIS_MASTER_NAME="redismaster"

# From https://unix.stackexchange.com/a/129401/304268
while getopts ":t:n:s:o:r:" opt; do
  case $opt in
	t) TAG="$OPTARG"
	;;
    n) NETWORK="$OPTARG"
    ;;
	s) REDIS_SENTINEL_NAME="$OPTARG"
	;;
	o) NUM_OF_SENTINELS="$OPTARG"
	;;
	r) NUM_OF_REDIS="$OPTARG"
	;;
    \?) echo "Invalid option -$OPTARG" >&2
    ;;
  esac
done

echo "Starting redis-zero"
docker service create --network $NETWORK --name redis-zero redis:5.0.9-alpine

echo "Starting services"
# docker stack deploy -c scripts/docker-compose.yml cache

until [ "$(docker run --rm --network $NETWORK mlaradji/redis-utils:$TAG \
	$REDIS_SENTINEL_NAME $REDIS_MASTER_NAME \
	value num-other-sentinels)" = "$((NUM_OF_SENTINELS - 1))" ]; do
	echo "Sentinels not set up yet - sleeping"
	sleep 2
done

until [ "$(docker run --rm --network $NETWORK mlaradji/redis-utils:$TAG \
	$REDIS_SENTINEL_NAME $REDIS_MASTER_NAME \
	value "num-slaves")" = "$NUM_OF_REDIS" ]; do
	echo "Slaves not set up yet - sleeping"
	sleep 2
done

old_master=$(docker run --rm --network $NETWORK mlaradji/redis-utils:$TAG \
	$REDIS_SENTINEL_NAME $REDIS_MASTER_NAME value ip)
echo "redis-zero ip is ${old_master}"

echo "Removing redis-zero"
docker service rm redis-zero

until [ "$(docker run --rm --network $NETWORK mlaradji/redis-utils:$TAG \
	$REDIS_SENTINEL_NAME $REDIS_MASTER_NAME value ip)" != "$old_master" ]; do
	echo "Failover did not happen yet - sleeping"
	sleep 2
done

echo "Make sure the number of slaves are set"
docker run --rm --network $NETWORK mlaradji/redis-utils:$TAG \
	$REDIS_SENTINEL_NAME $REDIS_MASTER_NAME reset "num-slaves" "$((NUM_OF_REDIS - 1))"
