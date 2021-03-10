#!/bin/bash

. ./version_check.sh

export HDDL_TEST_FILE=/run_forever.sh
if [ -z "$HDDL_KMB_COUNT" ]; then
    export HDDL_KMB_COUNT=3
fi
if [ -z "$JOB_TYPE" ]; then
    export JOB_TYPE=forever
fi
if [ -z "$HVA_TEST_TIMEOUT" ]; then
    export HVA_TEST_TIMEOUT=60
fi

export RANDOM_STR=`head /dev/urandom | tr -dc a-z0-9 | head -c10`
echo $RANDOM_STR
envsubst < sleep.yaml | kubectl apply -f -
