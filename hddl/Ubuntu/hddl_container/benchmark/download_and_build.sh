#!/bin/bash

#export HDDL_IMAGE_NAME=hddlunite_connect
#export HDDL_IMAGE_TAG=20201013-1636
#export HDDL_RESOURCE_FOLDER=/home/chunfung/CF/Benchmark_WS4
#export HOST_PACKAGE_LINK=https://ubit-artifactory-sh.intel.com/artifactory/sed-dgn-local/yocto/builds/2020/Mainline_BKC/20201013-1636
#export USER_EXTERNAL=chunfung

export KMB_LINK=$HOST_PACKAGE_LINK
jupyter nbconvert --to python kmb_dl_scripts.ipynb

rm dl_export
python3 ./kmb_dl_scripts.py

source dl_export

./image_build.sh
