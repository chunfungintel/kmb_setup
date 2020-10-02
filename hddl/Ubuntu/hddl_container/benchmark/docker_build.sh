#!/bin/bash

if [ -z "$BENCHMARK_IMAGE_NAME" ]; then
    echo "Need to set BENCHMARK_IMAGE_NAME "
    exit
fi

if [ -z "$BENCHMARK_IMAGE_TAG" ]; then
    echo "Need to set BENCHMARK_IMAGE_TAG "
    exit
fi

if [ -z "$BENCHMARK_RESOURCE_FOLDER" ]; then
    echo "Need to set BENCHMARK_RESOURCE_FOLDER "
    exit
fi

if [ -z "$HOST_PACKAGE_LINK" ]; then
    echo "Need to set HOST_PACKAGE_LINK "
    exit
fi

if [ -z "$HOST_PACKAGE_NAME" ]; then
    echo "Need to set HOST_PACKAGE_NAME "
    exit
fi

#TODO
#rm -rf $HOST_PACKAGE_NAME
#wget $HOST_PACKAGE_LINK/$HOST_PACKAGE_NAME

docker build \
--no-cache=true \
-f ./dockerfiletest \
--build-arg HOST_PACKAGE_NAME \
-t $BENCHMARK_IMAGE_NAME:$BENCHMARK_IMAGE_TAG $BENCHMARK_RESOURCE_FOLDER

docker image ls
