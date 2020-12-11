#!/bin/bash

if [ -z "$1" ]; then
   echo 'usage: ./Setup_01.sh node_name'
   exit
fi

NODE=$1


select name in A0 B0 ;
do
  case "$name" in
        A0)
            build=A0
            break
          ;;
        B0)
            build=B0
            break
          ;;
  esac
done

if [ -z "$build" ]; then
    echo 'No build selected.'
    exit
fi



SERVER_IP=

cp ./resources/launch_gst_* /data
cp ./resources/cat1080_frm5.h264 /data
cp ./resources/$build/source* /data
cp -r ./resources/gst-video-analytics /data
cp -r ./resources/release_kmb /data

cp -r ./resources/avc_uncontained_woBframe /data
cp -r ./resources/textures /data

# memory resize
# fw_setenv kmb-skip-codec-resize 1

./setup_intel.sh $NODE
#./setup_vpu.sh

echo 'Please reboot your system for changes to take effect'

