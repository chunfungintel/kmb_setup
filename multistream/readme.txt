U can get gst-multithread.tar.gz from my host machine!
scp hddl@10.240.119.111: /home/hddl/gst-multithread.tar.gz[password: hddl1234]

Next u can refer to following steps:
1.      source ./kmb_evm_env_a0_M2I_20201105.sh
2.      chmod +x main
3.      ./main -l launch_h264_nireq_4_20201126.txt -n 4 &> gst_pipeline_1.txt &
4.      ./main -l launch_h264_nireq_4_20201126.txt -n 4 &> gst_pipeline_2.txt &
You can see that the two main processes are running!
After the end, you can check the gst_pipeline_X.txt to confirm whether it exited normally!

Pls contact me if there is some error to prevent u successfully performing the test!


