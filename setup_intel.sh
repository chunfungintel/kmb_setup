#!/bin/bash

if [ -z "$1" ]; then
   echo 'usage: ./setup_kmb <nodename>'
   exit
fi


select name in A0 B0 ;
do
  case "$name" in
        A0)
            build=A0
            break
          ;;
        B0)
            build=B0
            break
          ;;
  esac
done

if [ -z "$build" ]; then
    echo 'No build selected.'
    exit
fi


mount -o remount, rw /
mount -o remount, rw /data

nodename=$1

echo "setup k3s work node: $nodename"

PS3='Select the closest proxy server to this system: '
proxys=("United States" "India" "Israel" "Ireland" "Germany" "Malaysia" "China")
select proxy in "${proxys[@]}"
do
  case $proxy in
    "United States")
      server="proxy-us.intel.com"
      break
      ;;
    "India")
      server="proxy-iind.intel.com"
      break
      ;;
    "Israel")
      server="proxy-iil.intel.com"
      break
      ;;
    "Ireland")
      server="proxy-ir.intel.com"
      break
      ;;
    "Germany")
      server="proxy-mu.intel.com"
      break
      ;;
    "Malaysia")
      server="proxy-png.intel.com"
      break
      ;;
    "China")
      server="proxy-prc.intel.com"
      break
      ;;
    *) echo "Invalid proxy";;
  esac
done

function AddProxyLine {
  newline=$1
  searchstring=$2
  #Check if /etc/environment already has that variable
  linenum="$(cat '/etc/environment' | grep -n ${searchstring} | grep -Eo '^[^:]+')"
  if [ "$?" -eq 0 ]; then
    #Sanitize the replacement line for sed
    safenewline="$(printf "${newline}" | sed -e 's/[\/&]/\\&/g')"
    #Actually do the replacement
    sudo sed -i "${linenum}s/.*/${safenewline}/" /etc/environment
  else
    #Append the line to the end of the file
    sudo bash -c "echo '${newline}' >> /etc/environment"
  fi
}

#echo $server
echo "writing /etc/environment"

AddProxyLine "http_proxy=http://${server}:911" "http_proxy"
AddProxyLine "https_proxy=http://${server}:912" "https_proxy"
AddProxyLine "ftp_proxy=http://${server}:911" "ftp_proxy"
AddProxyLine "socks_proxy=http://${server}:1080" "socks_proxy"
AddProxyLine "no_proxy=intel.com,.intel.com,10.0.0.0/8,192.168.0.0/16,localhost,.local,127.0.0.0/8,134.134.0.0/16" "no_proxy"
#You have to duplicate upper-case and lower-case because some programs
#only look for one or the other
AddProxyLine "HTTP_PROXY=http://${server}:911" "HTTP_PROXY"
AddProxyLine "HTTPS_PROXY=http://${server}:912" "HTTPS_PROXY"
AddProxyLine "FTP_PROXY=http://${server}:911" "FTP_PROXY"
AddProxyLine "SOCKS_PROXY=http://${server}:1080" "SOCKS_PROXY"
AddProxyLine "NO_PROXY=intel.com,.intel.com,10.0.0.0/8,192.168.0.0/16,localhost,.local,127.0.0.0/8,134.134.0.0/16" "NO_PROXY"

cat <<EOF > /etc/profile.d/Intel.sh
export http_proxy=http://${server}:911
export https_proxy=http://${server}:912
export ftp_proxy=http://${server}:911
export socks_proxy=http://${server}:1080
export no_proxy=intel.com,.intel.com,10.0.0.0/8,192.168.0.0/16,localhost,.local,127.0.0.0/8,134.134.0.0/16

export HTTP_PROXY=http://${server}:911
export HTTPS_PROXY=http://${server}:912
export FTP_PROXY=http://${server}:911
export SOCKS_PROXY=http://${server}:1080
export NO_PROXY=intel.com,.intel.com,10.0.0.0/8,192.168.0.0/16,localhost,.local,127.0.0.0/8,134.134.0.0/16


#export VPU_FIRMWARE_FILE="vpu_nvr.bin"
#export LD_LIBRARY_PATH=/opt/opencv/lib:/opt/InferenceEngine/lib/aarch64:/usr/lib/gstreamer-1.0:/usr/lib/gst-video-analytics
#export GST_PLUGIN_PATH=/usr/lib/gst-video-analytics
#source /opt/openvino/bin/setupvars.sh
#export GST_DEBUG=2
#export ENABLE_GVA_FEATURES=compact-meta
#export USE_SIPP=1
#export GST_VAAPI_ALL_DRIVERS=1
#export SIPP_FIRST_SHAVE=3
#ulimit -n 65532
#ulimit -c unlimited

EOF

echo "change hostname"
hostnamectl set-hostname "$nodename"

echo "sync date/time"
export http_proxy=http://${server}:911
date -s "$(curl --head -sS -H 'Cache-Control: no-cache' 'bing.com'  | grep '^Date:' | cut -d' ' -f3-6)Z"
hwclock -w

echo "setup docker proxy"
systemctl stop docker

mkdir -p /etc/systemd/system/docker.service.d
echo "[Service]
Environment=\"HTTP_PROXY=http://${server}:911/\"
Environment=\"HTTPS_PROXY=http://${server}:912/\"
Environment=\"NO_PROXY=localhost,.intel.com\"
" > /etc/systemd/system/docker.service.d/http-proxy.conf

mkdir -p ~/.docker
echo "{
        \"auths\": {
                \"gar-registry.caas.intel.com\": {
                        \"auth\": \"anN1bjMyOld5bGRzajclRmViMjAyMA==\"
                }
        },
        \"HttpHeaders\": {
                \"User-Agent\": \"Docker-Client/19.03.7 (linux)\"
        },
        \"proxies\": {
                \"default\": {
                        \"httpProxy\": \"http://${server}:911\",
                        \"httpsProxy\": \"http://${server}:912\",
                        \"noProxy\": \"intel.com,.intel.com,10.0.0.0/8,192.168.0.0/16,localhost,.local,127.0.0.0/8,134.134.0.0/16\"
                }
        }
}" > ~/.docker/config.json

cat <<EOF > /etc/docker/daemon.json
{
    "dns": ["10.248.2.1"]
}
EOF

if [ ! -d /data/docker ]; then 
  mv /var/lib/docker /data/
  ln -s /data/docker /var/lib/docker
fi

#source /etc/os-release
certsFile='IntelSHA2RootChain-Base64.zip'
certsUrl="http://certificates.intel.com/repository/certificates/$certsFile"
 
certsFolder='/usr/local/share/ca-certificates'
cmd='/usr/sbin/update-ca-certificates'
 
downloadCerts(){
  if ! [ -x "$(command -v unzip)" ]; then
    echo 'Error: unzip is not installed.' >&2
    exit 1
  fi
  http_proxy='' &&\
    wget $certsUrl -O $certsFolder/$certsFile
  unzip -u $certsFolder/$certsFile -d $certsFolder
  rm $certsFolder/$certsFile
}
 
installCerts(){
  chmod 644 $certsFolder/*.crt
  eval "$cmd"
}
 
mkdir -p /usr/local/share/ca-certificates
downloadCerts
installCerts

#cp systemd/syncdate /etc/init.d/
#cp systemd/date.service /etc/systemd/system
echo "NTP=10.128.4.200 10.128.4.201 corp.intel.com" >> /etc/systemd/timesyncd.conf


sed -i 's/\<data                auto       defaults\>/&,x-systemd.growfs/' /etc/fstab


systemctl daemon-reload

systemctl restart systemd-timesyncd
systemctl restart docker 
#systemctl start date
#systemctl enable date

timedatectl set-ntp true

echo "preparing resources"
mkdir -p /data/kmb
echo 0 > /data/kmb/vpu
echo 0 > /data/kmb/codec


echo 'Please reboot your system for changes to take effect'
