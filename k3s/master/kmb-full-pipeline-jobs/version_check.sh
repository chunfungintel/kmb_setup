#!/bin/bash

 export KMB_IMAGE_NAME=gar-registry.caas.intel.com/virtiot/kmb_full:20201013-1636

if [ -z "$KMB_IMAGE_NAME" ]; then
    echo "Need to set KMB_IMAGE_NAME "
    exit
fi

