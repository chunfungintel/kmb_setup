#!/bin/bash

IOTEDGE_CONFIG="/etc/iotedge/config.yaml"

if [ -z "$1" ]; then
    echo "No DEVICE CONNECTION STRING provided, please edit it manually in $IOTEDGE_CONFIG"
fi

device=$1

function SED_FORCE {
    original=$1
    replace=$2
    file=$3

    grep "$original" "$file" > /dev/null
    ret=$?
    if [ $ret -ne "0" ]; then
        echo "Error: $original not found in $file!!!"
        echo "Error: $replace set failed!!!"
	return
    fi

    sed -i "s/$original/$replace/" $file
}

SYSTEMD_EDITOR=tee systemctl edit iotedge <<EOF
[Service]
Environment="https_proxy=http://proxy-png.intel.com:912"
EOF

systemctl restart iotedge
systemctl show --property=Environment iotedge


cat <<EOF > /etc/docker/daemon.json
{
    "dns": ["10.248.2.1"]
}
EOF
systemctl restart docker

chmod +w /etc/iotedge/config.yaml

HOST=`hostname`
#sed -i "s/<ADD HOSTNAME HERE>/$HOST/" $IOTEDGE_CONFIG
SED_FORCE "<ADD HOSTNAME HERE>" $HOST /etc/iotedge/config.yaml

if [ -z "$1" ]; then

echo "Please provide device_connection_string in /etc/iotedge/config.yaml"
echo "Then run systemctl restart iotedge"

else

#sed -i "s/<ADD DEVICE CONNECTION STRING HERE>/$device/" $IOTEDGE_CONFIG
SED_FORCE "<ADD DEVICE CONNECTION STRING HERE>" $device /etc/iotedge/config.yaml
systemctl restart iotedge

fi
