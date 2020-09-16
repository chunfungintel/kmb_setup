#!/bin/bash

# https://rancher.com/docs/k3s/latest/en/installation/install-options
curl -sfL https://get.k3s.io | sh -

sudo chmod +r /etc/rancher/k3s/config.yaml
