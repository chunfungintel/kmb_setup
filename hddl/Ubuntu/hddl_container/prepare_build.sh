#!/bin/bash

if [ -z "$HDDL_RESOURCE_FOLDER" ]; then
    echo "Need to set HDDL_RESOURCE_FOLDER "
    exit
fi

rm -f $HDDL_RESOURCE_FOLDER/host_install_dir/hvasample/jpegenc-*.jpg

mv $HDDL_RESOURCE_FOLDER/host_install_dir/hvasample/config.json $HDDL_RESOURCE_FOLDER/host_install_dir/hvasample/config_original.json
cp resources/config.json $HDDL_RESOURCE_FOLDER/host_install_dir/hvasample/

#mv $HDDL_RESOURCE_FOLDER/host_install_dir/hvasample/FullPipeGUITestMulti $HDDL_RESOURCE_FOLDER/host_install_dir/hvasample/FullPipeGUITestMulti_original
#cp resources/FullPipeGUITestMulti $HDDL_RESOURCE_FOLDER/host_install_dir/hvasample/

cp ./resources/run_*.sh $HDDL_RESOURCE_FOLDER

