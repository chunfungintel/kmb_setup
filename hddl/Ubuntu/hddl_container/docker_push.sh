#!/bin/bash

if [ -z "$HDDL_IMAGE_NAME" ]; then
    echo "Need to set HDDL_IMAGE_NAME "
    exit
fi

if [ -z "$HDDL_IMAGE_TAG" ]; then
    echo "Need to set HDDL_IMAGE_TAG "
    exit
fi

docker login gar-registry.caas.intel.com

docker tag $HDDL_IMAGE_NAME:$HDDL_IMAGE_TAG gar-registry.caas.intel.com/virtio/$HDDL_IMAGE_NAME:$HDDL_IMAGE_TAG 

docker push gar-registry.caas.intel.com/virtio/$HDDL_IMAGE_NAME:$HDDL_IMAGE_TAG

