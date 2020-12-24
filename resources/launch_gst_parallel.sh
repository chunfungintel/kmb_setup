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

model_path=/data/release_kmb/yolo-v2-tiny-ava-0001.blob

gst-launch-1.0 multifilesrc location=/data/cat1080_frm5.h264 num-buffers=2000 \
! h264parse ! vaapih264dec ! videoconvert \
! gvadetect model=${model_path}  device=VPUX nireq=4 inference-interval=2 model-instance-id=1  model-proc=/usr/share/gst-video-analytics/samples/model_proc/yolo-v2-tiny-ava-0001.json   ie-config=VPUX_VPUAL_USE_CORE_NN=YES,VPUX_USE_M2I=YES  \
! gvafpscounter ! fakesink & \
model_path=/data/release_kmb/yolo-v2-tiny-ava-0001.blob
gst-launch-1.0 multifilesrc location=/data/cat1080_frm5.h264 num-buffers=2000 \
! h264parse ! vaapih264dec ! videoconvert \
! gvadetect model=${model_path}  device=VPUX nireq=4 inference-interval=2 model-instance-id=1  model-proc=/usr/share/gst-video-analytics/samples/model_proc/yolo-v2-tiny-ava-0001.json   ie-config=VPUX_VPUAL_USE_CORE_NN=YES,VPUX_USE_M2I=YES  \
! gvafpscounter ! fakesink & \
model_path=/data/release_kmb/yolo-v2-tiny-ava-0001.blob
gst-launch-1.0 multifilesrc location=/data/cat1080_frm5.h264 num-buffers=2000 \
! h264parse ! vaapih264dec ! videoconvert \
! gvadetect model=${model_path}  device=VPUX nireq=4 inference-interval=2 model-instance-id=1  model-proc=/usr/share/gst-video-analytics/samples/model_proc/yolo-v2-tiny-ava-0001.json   ie-config=VPUX_VPUAL_USE_CORE_NN=YES,VPUX_USE_M2I=YES  \
! gvafpscounter ! fakesink

sleep 10

oldnum=`cut -d ',' -f2 /data/kmb/vpu`
newnum=`expr $oldnum - $VPU_USED`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/vpu

oldnum=`cut -d ',' -f2 /data/kmb/codec`
newnum=`expr $oldnum - $CODEC_USED`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/codec

