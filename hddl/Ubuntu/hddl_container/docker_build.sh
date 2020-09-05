#!/bin/bash

if [ -z "$HDDL_IMAGE_TAG" ]; then
    echo "Need to set HDDL_IMAGE_TAG"
    exit
fi

docker build \
--no-cache=true \
-f ./dockerfile \
-t hddlunite:$HDDL_IMAGE_TAG .
#-t gar-registry.caas.intel.com/virtiot/hddl_hddlunite:20200822-0054 .

docker image ls
