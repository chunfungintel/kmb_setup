#!/bin/bash

if [ -z "$KMB_IMAGE_NAME" ]; then
    echo "Need to set KMB_IMAGE_NAME "
    exit
fi

if [ -z "$KMB_IMAGE_TAG" ]; then
    echo "Need to set KMB_IMAGE_TAG "
    exit
fi


docker login gar-registry.caas.intel.com

docker tag $KMB_IMAGE_NAME:$KMB_IMAGE_TAG gar-registry.caas.intel.com/virtiot/$KMB_IMAGE_NAME:$KMB_IMAGE_TAG 

docker push gar-registry.caas.intel.com/virtiot/$KMB_IMAGE_NAME:$KMB_IMAGE_TAG

docker image ls
