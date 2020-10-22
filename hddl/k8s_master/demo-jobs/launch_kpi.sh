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

export HDDL_TEST_FILE=/run_kpi.sh
if [ -z "$HDDL_KMB_COUNT" ]; then
    export HDDL_KMB_COUNT=3
fi
if [ -z "$JOB_TYPE" ]; then
    export JOB_TYPE=kpi
fi
if [ -z "$HVA_TEST_TIMEOUT" ]; then
    export HVA_TEST_TIMEOUT=60
fi

export RANDOM_STR=`head /dev/urandom | tr -dc a-z0-9 | head -c10`
#echo $RANDOM_STR
envsubst < deployment.yaml | kubectl apply -f -
export KPI_POD_ID=job.batch/kpi-$RANDOM_STR-01

