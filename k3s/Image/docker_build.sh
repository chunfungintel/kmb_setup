#!/bin/bash

if [ -z "$KMB_IMAGE_NAME" ]; then
    echo "Need to set KMB_IMAGE_NAME "
    exit
fi

if [ -z "$KMB_IMAGE_TAG" ]; then
    echo "Need to set KMB_IMAGE_TAG "
    exit
fi

if [ -z "$KMB_IMAGE_LINK" ]; then
    echo "Need to set KMB_IMAGE_LINK "
    exit
fi

export KMB_IMAGE_NAME=kmb_full
export KMB_IMAGE_TAG=20201013-1636
export KMB_IMAGE_LINK=https://ubit-artifactory-sh.intel.com/artifactory/sed-dgn-local/yocto/builds/2020/Mainline_BKC/20201013-1636

sudo ls

KMB_ROOTFS=system.img
wget $KMB_IMAGE_LINK/$KMB_ROOTFS.gz
gunzip $KMB_ROOTFS.gz

KMB_ROOT_FS_MOUNT=mnt
mkdir -p ./$KMB_ROOT_FS_MOUNT
sudo mount -t auto $KMB_ROOTFS $KMB_ROOT_FS_MOUNT

cd $KMB_ROOT_FS_MOUNT
sudo rm -rf ./lost+found
cat <<EOF | sudo tee dockerfile
FROM scratch

ADD .  /
EOF

sudo docker build \
--no-cache=true \
-f ./dockerfile \
-t $KMB_IMAGE_NAME:$KMB_IMAGE_TAG .


