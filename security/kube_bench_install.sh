#!/bin/bash

export MY_GO=/data/go
export GOPATH=$MY_GO/home
export GOROOT=$MY_GO/root/go
export GO_INSTALL=$MY_GO/root
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

go get github.com/aquasecurity/kube-bench && \
cd $GOPATH/src/github.com/aquasecurity/kube-bench && \
go build -o kube-bench .

