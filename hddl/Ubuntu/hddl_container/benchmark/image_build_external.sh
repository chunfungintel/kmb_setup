#!/bin/bash

#export HDDL_IMAGE_NAME=hddlunite_connect
#export HDDL_IMAGE_TAG=20201003-0611
#export HDDL_RESOURCE_FOLDER=/home/chunfung/CF/Benchmark_WS
#export HOST_PACKAGE_LINK=https://ubit-artifactory-sh.intel.com/artifactory/sed-dgn-local/yocto/builds/2020/PREINT/20201003-0611
#export HOST_PACKAGE_NAME=bypass_host_hddlunite_hvasample_demo-2327426.tgz
#export OPENVINO_PACKAGE_NAME=l_openvino_toolkit_private_ubuntu18_kmb_x86_p_2021.1.0-1237-3cabe58ed07-releases_2020_kmb_pv2.tar.gz
#export DEB_PACKAGE_NAME=kmb-hddl-driver-dkms_0.1.0-eabaa_all.deb

if [ -z "$HDDL_IMAGE_NAME" ]; then
    echo "Need to set HDDL_IMAGE_NAME "
    exit
fi

if [ -z "$HDDL_IMAGE_TAG" ]; then
    echo "Need to set HDDL_IMAGE_TAG "
    exit
fi

if [ -z "$HDDL_RESOURCE_FOLDER" ]; then
    echo "Need to set HDDL_RESOURCE_FOLDER "
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

if [ -z "$DEB_PACKAGE_NAME" ]; then
    echo "Need to set DEB_PACKAGE_NAME "
    exit
fi

mkdir -p $HDDL_RESOURCE_FOLDER

rm -rf $HDDL_RESOURCE_FOLDER/$HOST_PACKAGE_NAME
wget https://ubit-artifactory-sh.intel.com/artifactory/sed-dgn-local/yocto/builds/2020/Mainline_BKC/20201013-1636/host_packages/$HOST_PACKAGE_NAME -P $HDDL_RESOURCE_FOLDER

rm -rf $HDDL_RESOURCE_FOLDER/$OPENVINO_PACKAGE_NAME
wget --user=$USER --ask-password $HOST_PACKAGE_LINK/IA_Host_OpenVINO_toolkit/$OPENVINO_PACKAGE_NAME -P $HDDL_RESOURCE_FOLDER

rm -rf $HDDL_RESOURCE_FOLDER/$DEB_PACKAGE_NAME
wget --user=$USER --ask-password $HOST_PACKAGE_LINK/IA_Host_platform_manageability_package/$DEB_PACKAGE_NAME -P $HDDL_RESOURCE_FOLDER

cp -r ./scripts/* $HDDL_RESOURCE_FOLDER
cp ../../../../resources/release_kmb/* $HDDL_RESOURCE_FOLDER/test

docker build \
--no-cache=true \
-f ./dockerfiletest \
--build-arg HOST_PACKAGE_NAME \
--build-arg OPENVINO_PACKAGE_NAME \
--build-arg DEB_PACKAGE_NAME \
-t $HDDL_IMAGE_NAME:$HDDL_IMAGE_TAG $HDDL_RESOURCE_FOLDER

docker image ls
