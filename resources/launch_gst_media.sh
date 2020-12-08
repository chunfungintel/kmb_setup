echo "Start testing:"
date

export MAX_SUPPORT_CODEC=4

export CODEC_USED=$((100/$MAX_SUPPORT_CODEC))

oldnum=`cut -d ',' -f2 /data/kmb/codec`
newnum=`expr $oldnum + $CODEC_USED`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/codec

source /data/source_container.env
export OUTPUT_MP4="test_$VIDEO_NAME.avi"

cd /data/avc_uncontained_woBframe;

#gst-launch-1.0 -v filesrc location="/data/cat1080_frm5.h264" num-buffers=10 \
gst-launch-1.0 multifilesrc location="%02d.h264" index=11 stop-index=20 \
! h264parse ! vaapih264dec \
! "video/x-raw(memory:DMABuf)" ! videoconvert \
! vaapih264enc ! avimux ! filesink location=$OUTPUT_MP4

#gst-launch-1.0 multifilesrc location="%02d.h264" index=11 stop-index=20 ! h264parse ! vaapih264dec ! "video/x-raw(memory:DMABuf)" \
#! capsfilter name=dma_buf \
#! fakesink async=false
#! vaapih264enc ! avimux ! filesink location=$OUTPUT_MP4

oldnum=`cut -d ',' -f2 /data/kmb/codec`
newnum=`expr $oldnum - $CODEC_USED`
sed -i "s/$oldnum\$/$newnum/g" /data/kmb/codec

echo "Testing end:"
date

