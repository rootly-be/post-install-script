#!/bin/bash
USERNAME=$1
WORKER_SIZE=3
MANAGER_SIZE=1
DOCKER_MACHINE_DRIVER=virtualbox

## CREATE MANAGER

function create_manager() {
	for in in $(seq 1 ${MANAGER_SIZE})
	do
		set -xe
		NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
		docker-machine create -d ${DOCKER_MACHINE_DRIVER} ${MACHINE_OPTS} manager-${i}-${USERNAME}-${NEW_UUID}
		set +xe
	done
}

function create_worker() {
	for in in $(seq 1 ${WORKER_SIZE})
	do
		set -xe
		NEW_UUID=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
		docker-machine create -d ${DOCKER_MACHINE_DRIVER} ${MACHINE_OPTS} node-${i}-${USERNAME}-${NEW_UUID}
		set +xe
	done
}

create_manager
create_worker


#docker swarm init --advertise-addr vboxnet0

#docker-machine create --driver virtualbox manager
#docker-machine create --driver virtualbox node1
#docker-machine create --driver virtualbox node2
#docker-machine create --driver virtualbox node3

#eval $(docker-machine env node1)
#docker swarm join --token SWMTKN-1-1u195tkhx3hcdp4im603eyf2lqkuw4ld6b7mabhxamaouqzl7t-4hpfjl6fhxq52crl66xfcz356 192.168.99.1:2377
#eval $(docker-machine env node2)
#docker swarm join --token SWMTKN-1-1u195tkhx3hcdp4im603eyf2lqkuw4ld6b7mabhxamaouqzl7t-4hpfjl6fhxq52crl66xfcz356 192.168.99.1:2377
#eval $(docker-machine env node3)
#docker swarm join --token SWMTKN-1-1u195tkhx3hcdp4im603eyf2lqkuw4ld6b7mabhxamaouqzl7t-4hpfjl6fhxq52crl66xfcz356 192.168.99.1:2377
