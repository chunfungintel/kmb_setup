#!/bin/bash

kubectl create -f fullpipe.yaml
sleep 5
kubectl create -f fullpipe2.yaml

