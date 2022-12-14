#!/bin/bash

#export HDDL_IMAGE_NAME=hddlunite_connect
#export HDDL_IMAGE_TAG=20201003-0611
#export HDDL_RESOURCE_FOLDER=/home/chunfung/CF/Benchmark_WS
#export HOST_PACKAGE_LINK=https://ubit-artifactory-sh.intel.com/artifactory/sed-dgn-local/yocto/builds/2020/PREINT/20201003-0611
#export HOST_PACKAGE_NAME=bypass_host_hddlunite_hvasample_demo-2327426.tgz
#export OPENVINO_PACKAGE_NAME=l_openvino_toolkit_private_ubuntu18_kmb_x86_p_2021.1.0-1237-3cabe58ed07-releases_2020_kmb_pv2.tar.gz
#export DEB_PACKAGE_NAME=kmb-hddl-driver-dkms_0.1.0-eabaa_all.deb

function CHECK_MANDATORY {
    LIST_STRING=$1
    EXIT=0
    for STRING in $LIST_STRING
    do
        if [ -z "${!STRING}" ]; then
            echo "Need to export ${STRING}="
            EXIT=1
        fi
    done
    if [ $EXIT -eq 1 ]; then
        exit
    fi
}

CHECK_MANDATORY HDDL_IMAGE_NAME\ HDDL_IMAGE_TAG\ HDDL_RESOURCE_FOLDER\ HOST_PACKAGE_LINK\ VPU_ACCELERATOR_PKG\ OPENVINO_PACKAGE_NAME\ DEB_PACKAGE_NAME
#CHECK_MANDATORY HDDL_IMAGE_NAME\ HDDL_IMAGE_TAG\ HDDL_RESOURCE_FOLDER\ HOST_PACKAGE_LINK\ HOST_PACKAGE_NAME\ OPENVINO_PACKAGE_NAME\ DEB_PACKAGE_NAME


if [ -z ${USER_EXTERNAL+x} ]; then
  echo "var is unset";
else
  export WGET_TAG="--user=$USER_EXTERNAL --ask-password"
fi

#mkdir -p $HDDL_RESOURCE_FOLDER
#TODO
#rm -rf $HDDL_RESOURCE_FOLDER/$HOST_PACKAGE_NAME
#wget $WGET_TAG  $HOST_PACKAGE_LINK/host_packages/$HOST_PACKAGE_NAME -P $HDDL_RESOURCE_FOLDER

rm -rf $HDDL_RESOURCE_FOLDER/$VPU_ACCELERATOR_PKG
rm -rf $HDDL_RESOURCE_FOLDER/$OPENVINO_PACKAGE_NAME
rm -rf $HDDL_RESOURCE_FOLDER/$DEB_PACKAGE_NAME

export DL_LIST=wget.txt

echo "$HOST_PACKAGE_LINK/host_packages/$VPU_ACCELERATOR_PKG" > $DL_LIST
echo "$HOST_PACKAGE_LINK/$OPENVINO_PACKAGE_NAME" >> $DL_LIST
echo "$HOST_PACKAGE_LINK/host_packages/$DEB_PACKAGE_NAME" >> $DL_LIST
echo "$HOST_PACKAGE_LINK/blobs/compiled-models-gva.tar.bz2" >> $DL_LIST
echo "$HOST_PACKAGE_LINK/blobs/compiled-models.tar.bz2" >> $DL_LIST

wget $WGET_TAG -i $DL_LIST -P $HDDL_RESOURCE_FOLDER

cp -r ./scripts/* $HDDL_RESOURCE_FOLDER
#cp ../../../../resources/release_kmb/* $HDDL_RESOURCE_FOLDER/test

tar -xvf $HDDL_RESOURCE_FOLDER/compiled-models-gva.tar.bz2 --directory=$HDDL_RESOURCE_FOLDER
tar -xvf $HDDL_RESOURCE_FOLDER/compiled-models.tar.bz2 --directory=$HDDL_RESOURCE_FOLDER
cp $HDDL_RESOURCE_FOLDER/compiled-models/resnet-50-pytorch.blob $HDDL_RESOURCE_FOLDER/test
cp $HDDL_RESOURCE_FOLDER/compiled-models/yolo-v2-tiny-ava-0001.blob $HDDL_RESOURCE_FOLDER/test
mkdir -p $HDDL_RESOURCE_FOLDER/models
cp $HDDL_RESOURCE_FOLDER/compiled-models/mobilenet-v2.blob $HDDL_RESOURCE_FOLDER/models


docker build \
--no-cache=false \
-f ./dockerfiletest \
--build-arg VPU_ACCELERATOR_PKG \
--build-arg OPENVINO_PACKAGE_NAME \
--build-arg DEB_PACKAGE_NAME \
-t $HDDL_IMAGE_NAME:$HDDL_IMAGE_TAG $HDDL_RESOURCE_FOLDER

docker image ls
