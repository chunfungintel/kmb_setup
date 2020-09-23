#!/bin/bash

echo $MEDIA_CONTAINER_ID_LIST
for CONTAINER in $MEDIA_CONTAINER_ID_LIST; 
do
    docker logs $CONTAINER | tail -20
    echo "---------------------------------------------------------"
done
