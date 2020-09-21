#!/bin/bash

echo $KPI_CONTAINER_ID_LIST
for CONTAINER in $KPI_CONTAINER_ID_LIST; 
do
    docker logs $CONTAINER | tail -20
    echo "---------------------------------------------------------"
done
