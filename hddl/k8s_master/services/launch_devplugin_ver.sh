#!/bin/bash


export DEV_PLUGIN_IMAGE_NAME=gar-registry.caas.intel.com/virtiot/hddl_dev_plugin
export DEV_PLUGIN_IMAGE_TAG=$HDDL_IMAGE_TAG
envsubst < devplugin_ver.yaml | kubectl apply -f -
