#!/bin/bash

if [ -z "$KPI_START" ]; then
    echo "no sleep"
else
    sleep $KPI_START
fi


cd /KPI ;\
source bin/setupvars.sh ;\
deployment_tools/inference_engine/bin/benchmark_app -m ./models/mobilenet-v2.blob -d HDDL2 -nireq 4 -niter 3000 -i /textures
