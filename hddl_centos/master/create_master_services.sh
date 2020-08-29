#!/bin/bash


kubectl create -f hddl.yaml; \
sleep 5; \
kubectl create -f devplugin.yaml; \

