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
NUM_CONTAINER=3
export MEDIA_CONTAINER_ID_LIST=

for i in $( seq 1 $NUM_CONTAINER )
do
    container_id=$(docker run -d \
    -v /data:/data \
    --env VIDEO_NAME=$i \
    --device=/dev/xlnk:/dev/xlnk \
    --device=/dev/vpusmm0:/dev/vpusmm0 \
    --device=/dev/dri/renderD129:/dev/dri/renderD129 \
    --device=/dev/mem:/dev/mem \
    --cap-add SYS_RAWIO \
    $KMB_CONTAINER bash /data/launch_gst_media.sh)
    echo "TEST $i: $container_id"
    MEDIA_CONTAINER_ID_LIST="$MEDIA_CONTAINER_ID_LIST $container_id"
done


