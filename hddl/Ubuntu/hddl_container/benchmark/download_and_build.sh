#!/bin/bash

export HDDL_IMAGE_NAME=hddlunite_connect
export HDDL_IMAGE_TAG=20201013-1636
export HDDL_RESOURCE_FOLDER=/home/chunfung/CF/Benchmark_WS4
export HOST_PACKAGE_LINK=https://ubit-artifactory-sh.intel.com/artifactory/sed-dgn-local/yocto/builds/2020/Mainline_BKC/20201013-1636
export KMB_LINK=$HOST_PACKAGE_LINK

#export HOST_PACKAGE_NAME=bypass_host_hddlunite_hvasample_demo-2327426.tgz
#export OPENVINO_PACKAGE_NAME=l_openvino_toolkit_private_ubuntu18_kmb_x86_p_2021.1.0-1237-3cabe58ed07-releases_2020_kmb_pv2.tar.gz
#export DEB_PACKAGE_NAME=kmb-hddl-driver-dkms_0.1.0-eabaa_all.deb


jupyter nbconvert --to python kmb_dl_scripts.ipynb

rm dl_export
python3 ./kmb_dl_scripts.py

source dl_export

./image_build.sh
