#!/bin/bash
cd /host_install_dir/hvasample
source /host_install_dir/hvasample/prepare_run.sh
./FullPipe &
./FullPipeGUITestMulti 1

