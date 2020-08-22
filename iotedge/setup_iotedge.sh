#!/bin/bash

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
sed -i "s/<ADD HOSTNAME HERE>/$HOST/" /etc/iotedge/config.yaml

echo "Please provide device_connection_string in /etc/iotedge/config.yaml"
echo "Then run systemctl restart iotedge"
