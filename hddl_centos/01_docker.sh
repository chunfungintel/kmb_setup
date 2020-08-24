#!/bin/bash

sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine;
sudo yum install -y yum-utils;
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo;
sudo yum install -y https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm;
sudo yum install -y docker-ce docker-ce-cli;
yum list docker-ce --showduplicates | sort -r;
sudo systemctl start docker;
current_user=$USER;
sudo usermod -aG docker $current_user

