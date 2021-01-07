#!/bin/bash

USE_CACHE=true

git clone https://github.com/intel/edge-ai-resource-monitoring-deployment
pushd edge-ai-resource-monitoring-deployment/Prometheus-Server
docker build --no-cache=$USE_CACHE -f dockerfile -t prometheus-server-test:1.0 .

git clone https://github.com/intel/edge-ai-collectd.git
pushd edge-ai-collectd
docker build --no-cache=$USE_CACHE -f dockerfile -t collectd-test:1.0 .
