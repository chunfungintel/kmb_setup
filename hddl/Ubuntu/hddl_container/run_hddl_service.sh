#!/bin/bash
rm -rf /var/tmp/mode_set
rm -rf /tmp/mode_set

sleep 10
cd /host_install_dir/hvasample
source /host_install_dir/hvasample/prepare_run.sh
/host_install_dir/hddlunite/bin/SetHDDLMode -m bypass
sleep infinity

