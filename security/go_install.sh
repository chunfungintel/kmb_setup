#!/bin/bash

export MY_GO=/data/go
export GOPATH=$MY_GO/home
export GOROOT=$MY_GO/root/go
export GO_INSTALL=$MY_GO/root
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH

export GOLANG_ARM_DL=https://golang.org/dl
export GOLANG_ARM_TAR=go1.15.3.linux-arm64.tar.gz
mkdir -p $GO_INSTALL
mkdir -p $GOPATH/src

wget $GOLANG_ARM_DL/$GOLANG_ARM_TAR -P $MY_GO && \
tar -C $GO_INSTALL -xzf $MY_GO/$GOLANG_ARM_TAR
