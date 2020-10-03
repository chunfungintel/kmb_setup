#!/bin/bash

export BENCHMARK_IMAGE_NAME=benchmark_kpi
export BENCHMARK_IMAGE_TAG=20201002-0010
export BENCHMARK_RESOURCE_FOLDER=/home/chunfung/CF/Benchmark_WS
export HOST_PACKAGE_LINK=https://ubit-artifactory-sh.intel.com/artifactory/sed-dgn-local/yocto/builds/2020/Mainline_BKC/20201002-0010
export HOST_PACKAGE_NAME=bypass_host_hddlunite_hvasample_demo-6b3c42b.tgz
export OPENVINO_PACKAGE_NAME=l_openvino_toolkit_private_ubuntu18_kmb_x86_p_2020.3.0-3362-dc895cd9dcf-releases_2020_kmb_pv1.tar.gz


if [ -z "$BENCHMARK_IMAGE_NAME" ]; then
    echo "Need to set BENCHMARK_IMAGE_NAME "
    exit
fi

if [ -z "$BENCHMARK_IMAGE_TAG" ]; then
    echo "Need to set BENCHMARK_IMAGE_TAG "
    exit
fi

if [ -z "$BENCHMARK_RESOURCE_FOLDER" ]; then
    echo "Need to set BENCHMARK_RESOURCE_FOLDER "
    exit
fi

if [ -z "$HOST_PACKAGE_LINK" ]; then
    echo "Need to set HOST_PACKAGE_LINK "
    exit
fi

if [ -z "$HOST_PACKAGE_NAME" ]; then
    echo "Need to set HOST_PACKAGE_NAME "
    exit
fi

if [ -z "$OPENVINO_PACKAGE_NAME" ]; then
    echo "Need to set OPENVINO_PACKAGE_NAME "
    exit
fi

#TODO
rm -rf $BENCHMARK_RESOURCE_FOLDER/$HOST_PACKAGE_NAME
wget $HOST_PACKAGE_LINK/host_packages/$HOST_PACKAGE_NAME -P $BENCHMARK_RESOURCE_FOLDER

rm -rf $BENCHMARK_RESOURCE_FOLDER/$OPENVINO_PACKAGE_NAME
wget $HOST_PACKAGE_LINK/$OPENVINO_PACKAGE_NAME -P $BENCHMARK_RESOURCE_FOLDER



docker build \
--no-cache=true \
-f ./dockerfiletest \
--build-arg HOST_PACKAGE_NAME \
--build-arg OPENVINO_PACKAGE_NAME \
-t $BENCHMARK_IMAGE_NAME:$BENCHMARK_IMAGE_TAG $BENCHMARK_RESOURCE_FOLDER

docker image ls
