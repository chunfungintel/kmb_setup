oldnum=`cut -d ',' -f2 /data/kmb/vpu`
newnum=`expr $oldnum + 100`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/vpu

oldnum=`cut -d ',' -f2 /data/kmb/codec`
newnum=`expr $oldnum + 30`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/codec

source /data/source_container.env


GVADETECT_MODEL=/opt/release_kmb/yolo-v2-tiny-ava-0001.blob
GVADETECT_MODEL_PROC=/usr/share/gst-video-analytics/samples/model_proc/yolo-v2-tiny-ava-0001.json
GVACLASSIFY_MODEL=/opt/release_kmb/resnet-50-pytorch.blob
GVACLASSIFY_MODEL_PROC=/usr/share/gst-video-analytics/samples/model_proc/resnet-50-pytorch.json

gst-launch-1.0 multifilesrc location=/data/cat1080_frm5.h264 num-buffers=500 \
! h264parse ! vaapih264dec ! "video/x-raw(memory:DMABuf)" ! capsfilter name=dma_buf \
! gvadetect model=$GVADETECT_MODEL device=KMB \
nireq=4 inference-interval=2 model-instance-id=1 pre-process-backend=ie \
model-proc=$GVADETECT_MODEL_PROC \
ie-config=VPU_KMB_PREPROCESSING_SHAVES=4,VPU_KMB_PREPROCESSING_LPI=8 \
! vasobjecttracker tracking-type=SHORT_TERM_IMAGELESS device=VPU ! queue \
! gvaclassify model=$GVACLASSIFY_MODEL device=KMB \
model-proc=$GVACLASSIFY_MODEL_PROC \
nireq=4 model-instance-id=2 pre-process-backend=ie \
ie-config=VPU_KMB_PREPROCESSING_SHAVES=4,VPU_KMB_PREPROCESSING_LPI=8 \
name=detect reclassify-interval=100 ! queue ! gvafpscounter interval=20 \
! fakesink async=false

sleep 60

oldnum=`cut -d ',' -f2 /data/kmb/vpu`
newnum=`expr $oldnum - 100`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/vpu

oldnum=`cut -d ',' -f2 /data/kmb/codec`
newnum=`expr $oldnum - 30`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/codec
