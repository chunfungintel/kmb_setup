#!/bin/bash

cat << EOF > /etc/modules-load.d/hantro.conf
hantrodriver
EOF

SERVICE="kmb_source_daemon"

cat << EOF > ./$SERVICE.sh
#!/bin/bash

DATE=\`date '+%Y-%m-%d %H:%M:%S'\`
echo "$SERVICE service started at \${DATE}" | systemd-cat -p info

printf "1\n3\n" | XLinkStartStop

while :
do
echo "Looping...";
sleep 60;
done

EOF
cp $SERVICE.sh /usr/bin/$SERVICE.sh
chmod +x /usr/bin/$SERVICE.sh


cat << EOF > ./$SERVICE.service

[Unit]
Description=$SERVICE systemd service.

[Service]
Type=simple
ExecStart=/bin/bash /usr/bin/$SERVICE.sh

[Install]
WantedBy=multi-user.target

EOF
cp $SERVICE.service /etc/systemd/system/$SERVICE.service
chmod 644 /etc/systemd/system/$SERVICE.service

systemctl enable $SERVICE

