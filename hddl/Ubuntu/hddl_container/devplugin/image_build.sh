#!/bin/bash

if [ -z "$DEV_PLUGIN_IMAGE_NAME" ]; then
    echo "Need to set DEV_PLUGIN_IMAGE_NAME "
    exit
fi

if [ -z "$DEV_PLUGIN_IMAGE_TAG" ]; then
    echo "Need to set DEV_PLUGIN_IMAGE_TAG "
    exit
fi

if [ -z "$DEV_PLUGIN_RESOURCE_FOLDER" ]; then
    echo "Need to set DEV_PLUGIN_RESOURCE_FOLDER "
    exit
fi

cd $DEV_PLUGIN_RESOURCE_FOLDER
rm -rf edge-ai-device-plugin
git clone https://github.com/intel/edge-ai-device-plugin

docker build \
--no-cache=false \
-f ./dockerfiletest \
-t $DEV_PLUGIN_IMAGE_NAME:$DEV_PLUGIN_IMAGE_TAG $DEV_PLUGIN_RESOURCE_FOLDER

docker image ls
