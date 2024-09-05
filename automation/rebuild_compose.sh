#!/usr/bin/env bash
echo Inside rebuild_compose

REBUILD_CONTAINER=$1

docker compose rm -f
docker compose build

OLD_CONTAINER=$(docker ps -aqf "name=$REBUILD_CONTAINER")

docker compose up -d --no-deps --scale $REBUILD_CONTAINER=2 --no-recreate $REBUILD_CONTAINER
echo scaled up
echo sleeping
sleep 30

docker container rm -f $OLD_CONTAINER
docker compose up -d --no-deps --scale $REBUILD_CONTAINER=1 --no-recreate $REBUILD_CONTAINER
echo scaled down

echo Reloading nginx config
docker exec -it mini-cloud-nginx-1 nginx -s reload

echo Remove tagless images not associated with a container 
docker image prune
