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
NUM_LOOP=100
LOG_FILE=loop.txt

NUM_PS=$(docker ps --format '{{.ID}}' | wc -l)
echo "Initial container: $NUM_PS"
date >> $LOG_FILE

for i in $( seq 1 $NUM_LOOP )
do
    echo "Test $i"
    . ./container.sh
    echo "Containers List: $KPI_CONTAINER_ID_LIST"

    # wait for test finish
    while [ $(docker ps --format '{{.ID}}' | wc -l) -ne $NUM_PS ]
    do
        echo "Polling"
        sleep 10
    done
    ./container_results.sh >> $LOG_FILE
done


