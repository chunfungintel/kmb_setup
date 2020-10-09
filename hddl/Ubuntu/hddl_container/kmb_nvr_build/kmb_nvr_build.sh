#!/bin/bash

if [ -z "$KMB_NVR_WS" ]; then
    echo "Need to set KMB_NVR_WS "
    exit
fi

if [ -z "$KMB_BUILD_LINK" ]; then
    echo "Need to set KMB_BUILD_LINK "
    exit
fi

sudo ls

mkdir -p $KMB_NVR_WS
KMB_NVR_FOLDER=$KMB_NVR_WS/kmb_nvr_build
pushd $KMB_NVR_WS
echo "KMB_NVR_FOLDER: $KMB_NVR_FOLDER"
if [ -d "KMB_NVR_FOLDER" ] 
then
    echo "Directory kmb_nvr_build exists." 
    exit
fi

KMB_NVR_GIT=ssh://git@gitlab.devtools.intel.com:29418/kmb_integration/kmb_nvr_build.git
#KMB_NVR_GIT=https://gitlab.devtools.intel.com/kmb_integration/kmb_nvr_build
git clone $KMB_NVR_GIT --branch develop

cd $KMB_NVR_FOLDER
cd deps

wget $KMB_BUILD_LINK/system.img.gz

OPENVINO_UBUNTU=l_openvino_toolkit_private_ubuntu18_kmb_x86_p_2021.1.0-1237-3cabe58ed07-releases_2020_kmb_pv2.tar.gz
wget $KMB_BUILD_LINK/$OPENVINO_UBUNTU

CORE_IMAGE_MANIFEST=core-image-minimal-keembay-20201002221950.manifest
wget $KMB_BUILD_LINK/$CORE_IMAGE_MANIFEST

HDDLUNITE_HOST=hddlunite-host_1.2.0-1967d797.tar.gz
wget $KMB_BUILD_LINK/$HDDLUNITE_HOST

XLINK_PCIE=
wget $KMB_BUILD_LINK/$XLINK_PCIE

HDDL_DRIVER=kmb-hddl-driver-dkms_0.1.0-1e8e5_all.deb
wget $KMB_BUILD_LINK/$HDDL_DRIVER


cd $KMB_NVR_FOLDER/bypass_mode
build_bypass.sh

popd
