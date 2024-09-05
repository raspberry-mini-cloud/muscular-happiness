#!/usr/bin/env bash
IMAGE_NAME=$1

IMAGE_ID=$(docker images | grep $IMAGE_NAME'\s*latest' | awk '{print $3'})


docker tag $IMAGE_ID $IMAGE_NAME:backup
echo 'created new image for' $IMAGE_NAME 'with tag backup'

docker rmi $IMAGE_NAME:latest
#echo 'Removed' $IMAGE_NAME 'with tag latest'
