#!/bin/bash
# ==============================================================================
# Copyright (C) <2018-2019> Intel Corporation
#
# SPDX-License-Identifier: MIT
# ==============================================================================

set -e

BASEDIR=$(dirname "$0")/../..
if [ -n ${GST_SAMPLES_DIR} ]; then
  source $BASEDIR/scripts/setup_env.sh
fi
source $BASEDIR/scripts/setlocale.sh

if [ -z ${1} ]; then
  echo "ERROR: set path to video"
  echo "Usage: ./tinyyolo_v2-2channels.sh <path/to/video.h264>"
  exit
fi

FILE=${1}
PRE_PROC=ie
MODEL=/opt/release_kmb/yolo-v2-tiny-ava-0001.blob
MODEL_PROC=$BASEDIR/samples/model_proc/yolo-v2-tiny-ava-0001.json

echo Running sample with following parameters:
echo GST_PLUGIN_PATH=${GST_PLUGIN_PATH}
echo LD_LIBRARY_PATH=${LD_LIBRARY_PATH}

PIPELINE="gst-launch-1.0 \
    filesrc location=$FILE ! h264parse ! vaapih264dec ! video/x-raw(memory:DMABuf) ! \
    gvadetect model=$MODEL device=KMB pre-process-backend=$PRE_PROC model-proc=$MODEL_PROC nireq=4 model-instance-id=1 ! \
    gvametaconvert format=json add-tensor-data=true ! \
    gvametapublish file-path=report1.json method=file file-format=json ! \
    fakesink async=false \
    filesrc location=$FILE ! h264parse ! vaapih264dec ! video/x-raw(memory:DMABuf) ! \
    gvadetect model=$MODEL device=KMB pre-process-backend=$PRE_PROC model-proc=$MODEL_PROC nireq=4 model-instance-id=1 ! \
    gvametaconvert format=json add-tensor-data=true ! \
    gvametapublish file-path=report2.json method=file file-format=json ! \
    fakesink async=false"

echo ${PIPELINE}
${PIPELINE}
