#!/bin/bash

kubectl delete -f ./kmb-full-pipeline-jobs/kmb-full-pipeline-job-1.yaml
sleep 5
kubectl delete -f ./kmb-full-pipeline-jobs/kmb-full-pipeline-job-2.yaml
sleep 5
kubectl delete -f ./kmb-full-pipeline-jobs/kmb-full-pipeline-job-3.yaml
sleep 5
kubectl delete -f ./kmb-full-pipeline-jobs/kmb-media-only-job-1.yaml
sleep 5
kubectl delete -f ./kmb-full-pipeline-jobs/kmb-media-only-job-2.yaml

