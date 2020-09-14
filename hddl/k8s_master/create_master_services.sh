#!/bin/bash


kubectl create -f ./services/hddl.yaml; \
sleep 5; \
kubectl create -f ./services/devplugin.yaml; \

