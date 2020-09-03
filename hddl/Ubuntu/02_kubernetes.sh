#!/bin/bash

echo "Official guide: https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/"

if [ -z "$1" ]; then
   echo 'Must set hostname!'
   exit
fi

nodename=$1

sudo hostnamectl set-hostname "$nodename"

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo swapoff -a
sudo sed -i 's/\/swapfile/#\/swapfile/' /etc/fstab


