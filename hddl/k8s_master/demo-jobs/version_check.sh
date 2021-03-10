#!/bin/bash


: '
sameple:

export HDDL_IMAGE_NAME=hddlunite_connect
export HDDL_IMAGE_TAG=20200912-0857
export HDDL_TEST_FILE=/run_kpi.sh
export HDDL_KMB_COUNT=3
'

if [ -z "$HDDL_IMAGE_NAME" ]; then
    echo "Need to set HDDL_IMAGE_NAME "
    exit
fi

if [ -z "$HDDL_IMAGE_TAG" ]; then
    echo "Need to set HDDL_IMAGE_TAG "
    exit
fi

