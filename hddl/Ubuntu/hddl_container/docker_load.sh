#!/bin/bash

if [ -z "$HDDL_IMAGE_NAME" ]; then
    echo "Need to set HDDL_IMAGE_NAME "
    exit
fi

if [ -z "$HDDL_IMAGE_TAG" ]; then
    echo "Need to set HDDL_IMAGE_TAG "
    exit
fi


docker load < $HDDL_IMAGE_NAME:$HDDL_IMAGE_TAG.tar.gz
