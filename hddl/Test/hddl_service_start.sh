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

#sudo chmod 666 /dev/xlnk ;\
docker run -d \
-v /tmp:/tmp \
-v /var/tmp:/var/tmp \
--device=/dev/xlnk:/dev/xlnk \
--env KPI_START=$KPI_START \
$HDDL_CONTAINER /run_hddl_service.sh


