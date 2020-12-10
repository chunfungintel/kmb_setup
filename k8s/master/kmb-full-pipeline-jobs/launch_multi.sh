#!/bin/bash

. ./version_check.sh

export RANDOM_STR=`head /dev/urandom | tr -dc a-z0-9 | head -c10`
echo $RANDOM_STR

export JOB_NAME=full-pipeline
export VPU_USAGE=low
export CODEC_USAGE=medium
export KMB_JOB_FILE=/data/launch_gst_multi.sh
export KMB_VPU_COUNT=1
export KMB_CODEC_COUNT=1

#envsubst < deployment.yaml
envsubst < deployment.yaml | kubectl apply -f -
