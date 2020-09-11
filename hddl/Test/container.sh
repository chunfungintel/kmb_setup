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

#sudo chmod 666 /dev/xlnk

for i in $( seq 1 $NUM_CONTAINER )
do
    num=$(printf "%02d" $i)
    CONTAINER_NAME=$NAME-$num
    echo $CONTAINER_NAME
    TIME=$((KPI_START*(NUM_CONTAINER -i)))
    #echo $TIME

    docker run -d \
        -v /tmp:/tmp \
        -v /var/tmp:/var/tmp \
        --device=/dev/xlnk:/dev/xlnk \
        --env KPI_START=$TIME \
	$HDDL_CONTAINER /run_kpi.sh
done


