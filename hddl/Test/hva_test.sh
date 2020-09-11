#!/bin/bash

if [ -z "$HDDL_IMAGE_NAME" ]; then
    echo "Need to set HDDL_IMAGE_NAME "
    exit
fi

if [ -z "$HDDL_IMAGE_TAG" ]; then
    echo "Need to set HDDL_IMAGE_TAG "
    exit
fi


HDDL_CONTAINER=$HDDL_IMAGE_NAME:$HDDL_IMAGE_TAG
CONTAINER_NAME=TEST01
KPI_START=5

#sudo chmod 666 /dev/xlnk ; \

docker run -it \
-v /var/tmp:/var/tmp \
--device=/dev/xlnk:/dev/xlnk \
--device=/dev/dri/card0:/dev/dri/card0 \
--env KPI_START=$KPI_START \
$HDDL_CONTAINER /run_test.sh


