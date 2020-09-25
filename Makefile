STACK=redis-cluster-docker-swarm
NODES_COUNT=3
REDIS_MASTER_NAME=$(STACK)

deploy:
	docker stack deploy ${STACK} --compose-file docker-compose.yaml;
	./scripts/bootstrap.sh -n ${STACK}_webnet -s ${STACK}_redis-sentinel -m ${REDIS_MASTER_NAME} -z ${STACK}_redis-zero -o${NODES_COUNT} -r${NODES_COUNT}

echo:
	echo $(STACK);
	echo $(NODES_COUNT);
	echo $(MASTER_NAME);