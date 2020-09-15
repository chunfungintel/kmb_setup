#!/bin/bash

# Azure Github: https://github.com/Azure/azure-iotedge/releases

# Version
# https://github.com/Azure/azure-iotedge/releases/tag/1.0.8

IoT_Edge_Folder=IoT_Edge

sudo dnf remove docker docker-client docker-client-latest \
docker-common docker-latest docker-latest-logrotate \
docker-logrotate docker-engine docker.io containerd runc docker-ce-cli

mkdir -p ./$IoT_Edge_Folder

wget \
-P ./$IoT_Edge_Folder
https://github.com/Azure/azure-iotedge/releases/download/1.0.8/moby-engine-3.0.6-centos.x86_64.rpm \
https://github.com/Azure/azure-iotedge/releases/download/1.0.8/moby-cli-3.0.6-centos.x86_64.rpm \
https://github.com/Azure/azure-iotedge/releases/download/1.0.8/libiothsm-std-1.0.8-2.el7.x86_64.rpm \
https://github.com/Azure/azure-iotedge/releases/download/1.0.8/iotedge-1.0.8-2.el7.x86_64.rpm

sudo dnf install -y ./$IoT_Edge_Folder/*.rpm


