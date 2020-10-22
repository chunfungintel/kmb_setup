#!/bin/bash

if [ -z "$HDDL_IMAGE_NAME" ]; then
    echo "Need to set HDDL_IMAGE_NAME "
    exit
fi

if [ -z "$HDDL_IMAGE_TAG" ]; then
    echo "Need to set HDDL_IMAGE_TAG "
    exit
fi

export HDDL_KMB_COUNT=1

export KPI_POD_ID_LIST=
for i in {1..3}
do
. ./launch_kpi.sh
KPI_POD_ID_LIST="$KPI_POD_ID_LIST $KPI_POD_ID"
done

