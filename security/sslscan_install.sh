#!/bin/bash

export MY_GO=/data

cd $MY_GO
git clone https://github.com/rbsec/sslscan.git
cd sslscan && \
make static $$ \
make install

