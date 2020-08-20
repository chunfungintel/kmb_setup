#!/bin/bash


if [ -z "$1" ]; then
   echo 'usage: ./launch.sh ip_addr_master'
   exit
fi

MASTER_IP=$1

source /data/source.env

setsid k3s agent --docker --server https://$MASTER_IP:6443 --token 1234

