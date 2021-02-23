#!/bin/bash


export DEV_PLUGIN_IMAGE_NAME=gar-registry.caas.intel.com/virtiot/hddl_dev_plugin
export DEV_PLUGIN_IMAGE_TAG=20210204-1500

envsubst < kmb-vpu-plugin.yaml | kubectl apply -f -
