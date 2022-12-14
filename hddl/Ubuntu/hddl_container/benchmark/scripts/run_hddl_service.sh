#!/bin/bash
rm -rf /tmp/mode_set
rm -rf /tmp/hddlunite_service_alive.mutex
rm -rf /tmp/hddlunite_service_ready.mutex
rm -rf /tmp/hddlunite_service_start_exit.mutex
rm -rf /tmp/hddlunite_service.sock

rm -rf /var/tmp/mode_set
rm -rf /var/tmp/hddlunite_service_alive.mutex
rm -rf /var/tmp/hddlunite_service_ready.mutex
rm -rf /var/tmp/hddlunite_service_start_exit.mutex
rm -rf /var/tmp/hddlunite_service.sock

sleep 10
cd $HDDLUNITE_PATH
source ./env_host.sh
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HDDLUNITE_PATH}/thirdparty/XLink/lib:${HDDLUNITE_PATH}/thirdparty/Pms/lib
SetHDDLMode -m bypass
sleep infinity

