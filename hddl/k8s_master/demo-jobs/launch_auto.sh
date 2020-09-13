#!/bin/bash

RANDOM_STR=`head /dev/urandom | tr -dc a-z0-9 | head -c10`

envsubst < deployment.yaml | kubectl apply -f -
