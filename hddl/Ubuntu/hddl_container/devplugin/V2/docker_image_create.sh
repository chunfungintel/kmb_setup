#!/bin/bash

git clone ssh://git@gitlab.devtools.intel.com:29418/kmb_hddl/kmb-device-plugin.git
pushd kmb-device-plugin

export HDDLUNITE_LINK=https://ubit-artifactory-sh.intel.com/artifactory/sed-dgn-local/yocto/builds/2021/Mainline_BKC/20210204-1500/host_packages
export HDDLUNITE_PKG=hddlunite-kmb-host_2.2.5-ecd76057.tar.gz
export DOCKERFILE_DP=vpu-device-plugin-for-k8s.ubuntu

export DEV_PLUGIN_IMAGE_NAME=gar-registry.caas.intel.com/virtiot/hddl_dev_plugin
export DEV_PLUGIN_IMAGE_TAG=20210204-1500

mkdir -p dep
wget -P ./dep $HDDLUNITE_LINK/$HDDLUNITE_PKG

#sed -i 's/dep\/\*\.tar\.gz/dep\/\*\.tgz/g' $DOCKERFILE_DP
#sed -i 's/\*\.tar\.gz/\*\.tgz/g' $DOCKERFILE_DP

docker build -t $DEV_PLUGIN_IMAGE_NAME:$DEV_PLUGIN_IMAGE_TAG -f $DOCKERFILE_DP .

