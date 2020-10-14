#!/bin/bash

if [ -z "$HDDL_IMAGE_NAME" ]; then
    echo "Need to set HDDL_IMAGE_NAME "
    exit
fi

if [ -z "$HDDL_IMAGE_TAG" ]; then
    echo "Need to set HDDL_IMAGE_TAG "
    exit
fi

if [ -z "$HDDL_RESOURCE_FOLDER" ]; then
    echo "Need to set HDDL_RESOURCE_FOLDER "
    exit
fi


docker build \
--no-cache=true \
-f ./dockerfile \
-t $HDDL_IMAGE_NAME:$HDDL_IMAGE_TAG $HDDL_RESOURCE_FOLDER

docker image ls
