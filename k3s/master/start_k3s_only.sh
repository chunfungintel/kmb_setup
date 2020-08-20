#!/bin/bash

#sed -i '2inameserver 10.43.0.10' /etc/resolv.conf

source /data/source.env

setsid k3s server --docker --token 1234 --kube-scheduler-arg="config=/etc/edge-ai/scheduler/sched-config-k3s.yaml"
