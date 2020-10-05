#!/bin/bash

cd $HVASAMPLE_PATH
source ./prepare_run.sh
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${HDDLUNITE_PATH}/thirdparty/XLink/lib
./FullPipe &

if [ -z "$HVA_TEST_TIMEOUT" ]; then
    ./FullPipeGUITestMulti 1
else
    timeout $HVA_TEST_TIMEOUT\s ./FullPipeGUITestMulti 1
fi

echo "Done"

