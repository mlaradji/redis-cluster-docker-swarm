STACK=redis-cluster-docker-swarm
NODES_COUNT=3
REDIS_MASTER_NAME=redismaster

deploy:
	docker stack deploy ${STACK} --compose-file docker-compose.yaml;
	./scripts/bootstrap.sh -t latest -n ${STACK}_webnet -s ${STACK}_redis_sentinel -m ${STACK} -z ${REDIS_MASTER_NAME} -o${NODES_COUNT} -r${NODES_COUNT}

echo:
	echo $(STACK);
	echo $(NODES_COUNT);