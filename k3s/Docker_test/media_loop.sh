#!/bin/bash

if [ -z "$KMB_IMAGE_NAME" ]; then
    echo "Need to set KMB_IMAGE_NAME "
    exit
fi

if [ -z "$KMB_IMAGE_TAG" ]; then
    echo "Need to set KMB_IMAGE_TAG "
    exit
fi

KMB_CONTAINER=$KMB_IMAGE_NAME:$KMB_IMAGE_TAG
NUM_LOOP=10
LOG_FILE=loop.txt

NUM_PS=$(docker ps --format '{{.ID}}' | wc -l)
echo "Initial container: $NUM_PS"
date >> $LOG_FILE

for i in $( seq 1 $NUM_LOOP )
do
    echo "Test $i"
    . ./media.sh
    echo "Containers List: $MEDIA_CONTAINER_ID_LIST"

    # wait for test finish
    while [ $(docker ps --format '{{.ID}}' | wc -l) -ne $NUM_PS ]
    do
        echo "Polling"
        sleep 10
    done
    ./media_results.sh >> $LOG_FILE
done


