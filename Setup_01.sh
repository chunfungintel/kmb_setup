#!/bin/bash

if [ -z "$1" ]; then
   echo 'usage: ./Setup_01.sh node_name'
   exit
fi

NODE=$1

SERVER_IP=

#git clone ssh://git@gitlab.devtools.intel.com:29418/hspe_sws_sys/hddl/vmc_demo_contents.git
#git clone ssh://git@gitlab.devtools.intel.com:29418/kmb_integration/host-demo-resources.git
#mv ./host-demo-resources/original/avc_uncontained_woBframe .

cp ./resources/launch_gst_* /data
cp ./resources/cat1080_frm5.h264 /data
cp ./resources/source* /data
cp -r ./resources/avc_uncontained_woBframe /data

#cp -r edge-ai /etc

./setup_intel.sh $NODE
