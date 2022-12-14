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

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# Set SELinux in permissive mode (effectively disabling it)
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet

# Disable swap
sudo swapoff -a
sudo sed -i 's/\/dev\/mapper\/cl-swap/#\/dev\/mapper\/cl-swap/' /etc/fstab

# Disable firewall
sudo systemctl stop firewalld
sudo systemctl disable firewalld




