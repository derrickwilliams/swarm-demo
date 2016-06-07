docker run -d -p 3376:3376 -t -v ~/.docker/machine/machines/swarmboss:/certs:ro swarm manage -H 0.0.0.0:3376 --tlsverify --tlscacert=/certs/ca.pem --tlscert=/certs/server.pem --tlskey=/certs/server-key.pem token://30872618da4b26135ffcfca1ac91b59e

docker run -d swarm join --addr=$(docker-machine ip minion-phil):2376 token://30872618da4b26135ffcfca1ac91b59e
docker run -d swarm join --addr=$(docker-machine ip minion-kevin):2376 token://30872618da4b26135ffcfca1ac91b59e

  DOCKER_HOST=$(docker-machine ip swarmboss):3376

docker run -d -p 3376:3376 -t -v ~/.docker/machine/machines/swarmboss:/certs:ro swarm bash
