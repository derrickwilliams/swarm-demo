#!/bin/bash
# 30872618da4b26135ffcfca1ac91b59e
docker run -d -v $(pwd)/html:/usr/share/nginx/html -v $(pwd)/nginx/config.d/cbax.conf:/etc/nginx/conf.d/cbax.conf -p 8000:80 --name cbaxlb nginx

docker run -d -p 192.168.99.101:3376 -t -v ~/.docker/machine/machines/swarmboss:/certs:ro swarm manage -H 0.0.0.0:3376 --tlsverify --tlscacert=/certs/ca.pem --tlscert=/certs/server.pem --tlskey=/certs/server-key.pem token://<cluster_id>

docker run -d -p 3376:3376 -t -v ~/.docker/machine/machines/$DOCKER_MACHINE_NAME:/certs:ro swarm manage -H 0.0.0.0:3376 --tlsverify --tlscacert=/certs/ca.pem --tlscert=/certs/server.pem --tlskey=/certs/server-key.pem token://30872618da4b26135ffcfca1ac91b59e

# docker run consul

# swarm master pointed at consul
# 'dw' refers to docker-machine where consul is running
docker-machine create -d virtualbox --swarm --swarm-master --swarm-discovery="consul://$(docker-machine ip $DOCKER_MACHINE_NAME):8500" --engine-opt="cluster-store=consul://$(docker-machine ip $DOCKER_MACHINE_NAME):8500" --engine-opt="cluster-advertise=eth1:2376" svr1


# swarm agent pointed at consul
docker-machine create -d virtualbox --swarm --swarm-discovery="consul://$(docker-machine ip $DOCKER_MACHINE_NAME):8500" --engine-opt="cluster-store=consul://$(docker-machine ip $DOCKER_MACHINE_NAME):8500" --engine-opt="cluster-advertise=eth1:2376" agnt1
# (run more times with different machine name to create more agent nodes)


# client
docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"leave_on_terminate": true}' consul agent -bind=${BIND_IP} -retry-join=<root agent ip>

# server
docker run -d --net=host -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' consul agent -server -bind=$BIND_IP -retry-join=<root agent ip> -bootstrap-expect=1


  docker run -d \
      -p "8500:8500" \
      -h "consul" \
      consul -server -bootstrap



docker-machine create \
-d virtualbox \
--swarm --swarm-master \
--swarm-discovery="consul://$(docker-machine ip consul1):8500" \
--engine-opt="cluster-store=consul://$(docker-machine ip consul1):8500" \
--engine-opt="cluster-advertise=eth1:2376" \
master1

docker-machine create -d virtualbox \
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip consul1):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip consul1):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
  client1