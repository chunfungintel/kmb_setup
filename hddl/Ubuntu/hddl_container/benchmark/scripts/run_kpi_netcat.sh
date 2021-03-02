#!/bin/bash

if [ -z "$KPI_START" ]; then
    echo "no sleep"
else
    sleep $KPI_START
fi


cd $OPENVINO_PATH
source bin/setupvars.sh
deployment_tools/inference_engine/bin/benchmark_app -m ./models/mobilenet-v2.blob -d VPUX -nireq 4 -niter 3000 -i /opt/textures | nc 10.226.76.241 12456

sleep 10
echo "Done"
