export MAX_SUPPORT_VPU=4
export MAX_SUPPORT_CODEC=4

export VPU_USED=$((100/$MAX_SUPPORT_VPU))
export CODEC_USED=$((100/$MAX_SUPPORT_CODEC))

oldnum=`cut -d ',' -f2 /data/kmb/vpu`
newnum=`expr $oldnum + $VPU_USED`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/vpu

oldnum=`cut -d ',' -f2 /data/kmb/codec`
newnum=`expr $oldnum + $CODEC_USED`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/codec


source /data/source_container.env
#printf "1\n3\n" | XLinkStartStop

/opt/openvino/deployment_tools/inference_engine/bin/aarch64/benchmark_app -m /data/release_kmb/resnet-50-pytorch.blob -d KMB -nireq 1 -niter 1000 -i /data/textures


sleep 10

oldnum=`cut -d ',' -f2 /data/kmb/vpu`
newnum=`expr $oldnum - $VPU_USED`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/vpu

oldnum=`cut -d ',' -f2 /data/kmb/codec`
newnum=`expr $oldnum - $CODEC_USED`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/codec


