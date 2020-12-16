#!/bin/bash


export KMB_IMAGE_NAME=kmb_full
export KMB_IMAGE_TAG=test

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

