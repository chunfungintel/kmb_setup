#!/bin/bash

# Launch services
kubectl create -f /etc/edge-ai/deploy/0-ros-deploy.yaml; \
sleep 5; \
sed 's%vpusmm0%vpumgr0%g' /etc/edge-ai/deploy/1-device_plugin_daemonset.yaml | kubectl create -f - ; \
sleep 5; \
kubectl create -f /etc/edge-ai/deploy/2-collectd_deploy.yaml; \
sleep 5; \
kubectl create -f /etc/edge-ai/deploy/3-prometheus-operator.yaml; \
sleep 5; \
kubectl create -f /etc/edge-ai/deploy/5-prometheus-adapter.yaml; \
sleep 5; \
kubectl create -f /etc/edge-ai/deploy/4-prometheus-inst.yaml
