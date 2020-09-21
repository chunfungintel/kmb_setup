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
NAME=TEST
KPI_START=1
NUM_CONTAINER=6
export KPI_CONTAINER_ID_LIST=
#sudo chmod 666 /dev/xlnk

for i in $( seq 1 $NUM_CONTAINER )
do
    container_id=$(docker run -d \
        -v /tmp:/var/tmp \
        --device=/dev/xlnk:/dev/xlnk \
        --env KPI_START=$TIME \
	$HDDL_CONTAINER /run_kpi.sh)
    echo "TEST $i: $container_id"
    KPI_CONTAINER_ID_LIST="$KPI_CONTAINER_ID_LIST $container_id"
done


