#!/bin/bash
# WARNING: This removes all docker services, images and containers.
docker service rm `docker service ls -q` || true && docker rm -f `docker ps -aq` || true && docker rmi -f `docker images -q` || true && docker network rm redis