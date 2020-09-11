#!/bin/bash

# Guide: https://docs.microsoft.com/en-us/azure/iot-edge/how-to-install-iot-edge-linux

curl https://packages.microsoft.com/config/ubuntu/18.04/multiarch/prod.list > ./microsoft-prod.list
sudo cp ./microsoft-prod.list /etc/apt/sources.list.d/

curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo cp ./microsoft.gpg /etc/apt/trusted.gpg.d/

#sudo apt update
#sudo apt install -y moby-engine
#sudo apt install -y moby-cli

sudo apt update
sudo apt install -y iotedge


