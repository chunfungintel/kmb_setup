#!/bin/bash

if [ -z "$IMAGE_NAME" ]; then
    echo "Need to set IMAGE_NAME "
    exit
fi

if [ -z "$IMAGE_TAG" ]; then
    echo "Need to set IMAGE_TAG "
    exit
fi

docker login gar-registry.caas.intel.com

for IMAGE in $IMAGE_NAME;
do
    docker tag $IMAGE:$IMAGE_TAG gar-registry.caas.intel.com/virtiot/$IMAGE:$IMAGE_TAG
    docker push gar-registry.caas.intel.com/virtiot/$IMAGE:$IMAGE_TAG
done



#docker tag $HDDL_IMAGE_NAME:$HDDL_IMAGE_TAG gar-registry.caas.intel.com/virtiot/$HDDL_IMAGE_NAME:$HDDL_IMAGE_TAG 
#docker push gar-registry.caas.intel.com/virtiot/$HDDL_IMAGE_NAME:$HDDL_IMAGE_TAG

