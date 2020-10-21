#!/bin/bash

echo $KPI_POD_ID_LIST
for CONTAINER in $KPI_POD_ID_LIST; 
do
    kubectl logs $CONTAINER | tail -40
    echo "---------------------------------------------------------"
done
