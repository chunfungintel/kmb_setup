#!/bin/bash

if [ -z "$1" ]; then
   echo 'usage: ./Setup_01.sh node_name'
   exit
fi

NODE=$1

SERVER_IP=

cp ./resources/launch_gst_* /data
cp ./resources/cat1080_frm5.h264 /data
cp ./resources/source* /data
cp -r ./resources/gst-video-analytics /data
cp -r ./resources/release_kmb /data

cp -r ./resources/avc_uncontained_woBframe /data

#cp -r edge-ai /etc

./setup_intel.sh $NODE
#./setup_vpu.sh

echo 'Please reboot your system for changes to take effect'

