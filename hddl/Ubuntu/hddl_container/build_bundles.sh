#!/bin/bash

MAKEDIR=$PWD

export BUILD_TAG=20201030-1350
export BUILD_FOLDER=/home/chunfung/CF/Benchmark_WS6
export HOST_PACKAGE_LINK=https://ubit-artifactory-sh.intel.com/artifactory/list/sed-dgn-local/yocto/builds/2020/PREINT/$BUILD_TAG

mkdir -p $BUILD_FOLDER

### HDDL image build ###
HDDL_BUILD_FOLDER=$PWD/benchmark
export HDDL_IMAGE_NAME=hddlunite_connect
export HDDL_IMAGE_TAG=$BUILD_TAG
export HDDL_RESOURCE_FOLDER=$BUILD_FOLDER
export KMB_LINK=$HOST_PACKAGE_LINK

pushd $HDDL_BUILD_FOLDER
./download_and_build.sh
popd

### Device Plugin build ###
DEV_PLUGIN_FOLDER=$PWD/devplugin
export DEV_PLUGIN_IMAGE_NAME=hddl_dev_plugin
export DEV_PLUGIN_IMAGE_TAG=$BUILD_TAG
export DEV_PLUGIN_RESOURCE_FOLDER=$BUILD_FOLDER

pushd $DEV_PLUGIN_FOLDER
./image_build.sh
popd

### Docker push ###
export IMAGE_NAME="$HDDL_IMAGE_NAME $DEV_PLUGIN_IMAGE_NAME"
export IMAGE_TAG=$BUILD_TAG

pushd $PWD/docker_tools
./docker_push_all.sh
popd
