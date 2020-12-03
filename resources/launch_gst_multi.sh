oldnum=`cut -d ',' -f2 /data/kmb/vpu`
newnum=`expr $oldnum + 100`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/vpu

oldnum=`cut -d ',' -f2 /data/kmb/codec`
newnum=`expr $oldnum + 100`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/codec

source /data/source_container.env


GVADETECT_MODEL=/data/release_kmb/yolo-v2-tiny-ava-0001.blob
GVADETECT_MODEL_PROC=/data/gst-video-analytics/samples/model_proc/yolo-v2-tiny-ava-0001.json
GVACLASSIFY_MODEL=/data/release_kmb/resnet-50-pytorch.blob
GVACLASSIFY_MODEL_PROC=/data/gst-video-analytics/samples/model_proc/resnet-50-pytorch.json

gst-launch-1.0 -v  multifilesrc location=/data/cat1080_frm5.h264 num-buffers=5000 \
! h264parse ! vaapih264dec ! "video/x-raw(memory:DMABuf)" ! capsfilter name=dma_buf \
! gvadetect model=$GVADETECT_MODEL device=VPUX nireq=4 inference-interval=2 \
model-instance-id=1 model-proc=$GVADETECT_MODEL_PROC \
ie-config=VPU_KMB_USE_CORE_NN=YES,VPU_KMB_USE_M2I=YES \
! vasobjecttracker tracking-type=SHORT_TERM_IMAGELESS device=VPU tracking-per-class=false \
! queue max-size-bytes=0 max-size-buffers=2 \
! gvaclassify model=$GVACLASSIFY_MODEL model-proc=$GVACLASSIFY_MODEL_PROC \
device=VPUX nireq=4 model-instance-id=2 \
ie-config=VPU_KMB_USE_SIPP=YES,VPU_KMB_USE_CORE_NN=YES \
model-instance-id=2 reclassify-interval=100 \
! gvafpscounter interval=1 ! fakesink sync=false

sleep 10

oldnum=`cut -d ',' -f2 /data/kmb/vpu`
newnum=`expr $oldnum - 100`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/vpu

oldnum=`cut -d ',' -f2 /data/kmb/codec`
newnum=`expr $oldnum - 100`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/codec
