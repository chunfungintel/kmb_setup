#!/bin/bash

if [ -z "$HDDL_RESOURCE_FOLDER" ]; then
    echo "Need to set HDDL_RESOURCE_FOLDER "
    exit
fi

rm -f $HDDL_RESOURCE_FOLDER/host_install_dir/hvasample/jpegenc-*.jpg

cp resources/config.json $HDDL_RESOURCE_FOLDER/host_install_dir/hvasample/
cp resources/FullPipeGUITestMulti $HDDL_RESOURCE_FOLDER/host_install_dir/hvasample/
cp ./run_*.sh $HDDL_RESOURCE_FOLDER

