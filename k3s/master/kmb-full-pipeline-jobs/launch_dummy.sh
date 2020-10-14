#!/bin/bash

./version_check.sh

export RANDOM_STR=`head /dev/urandom | tr -dc a-z0-9 | head -c10`
echo $RANDOM_STR

export JOB_NAME=dummy
export VPU_USAGE=low
export CODEC_USAGE=low
export KMB_IMAGE_NAME=ubuntu:20.04
export KMB_JOB_FILE=/data/launch_gst_dummy.sh
export KMB_VPU_COUNT=1
export KMB_CODEC_COUNT=1

#envsubst < deployment.yaml
envsubst < deployment.yaml | kubectl apply -f -
