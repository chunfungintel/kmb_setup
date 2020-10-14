#!/bin/bash

: '
sameple:

export HDDL_IMAGE_NAME=hddlunite_connect
export HDDL_IMAGE_TAG=20200912-0857
export HDDL_TEST_FILE=/run_kpi.sh
export HDDL_KMB_COUNT=3
'

export HDDL_IMAGE_NAME=gar-registry.caas.intel.com/virtiot/hddlunite_connect
RANDOM_STR=`head /dev/urandom | tr -dc a-z0-9 | head -c10`

envsubst < hddl_ver.yaml | kubectl apply -f -
