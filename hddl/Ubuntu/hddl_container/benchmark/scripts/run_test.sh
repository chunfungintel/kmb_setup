#!/bin/bash

cd $HVASAMPLE_PATH
source ./prepare_run.sh
./FullPipe &

if [ -z "$HVA_TEST_TIMEOUT" ]; then
    ./FullPipeGUITestMulti 1
else
    timeout $HVA_TEST_TIMEOUT\s ./FullPipeGUITestMulti 1
fi

echo "Done"

