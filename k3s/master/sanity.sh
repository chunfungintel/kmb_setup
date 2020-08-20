#!/bin/bash

kubectl get no
#root@master:/data/KMB_Setup# kubectl get no
#NAME        STATUS     ROLES    AGE    VERSION
#node-jf     NotReady   <none>   11h    v1.18.4+k3s1
#master-jf   NotReady   master   14h    v1.18.4+k3s1
#keembay     NotReady   master   14h    v1.18.4+k3s1
#master      Ready      master   2m7s   v1.18.4+k3s1


kubectl get po
#root@master:/data/KMB_Setup# kubectl get po
#NAME                                   READY   STATUS               RESTARTS   AGE
#collectd-7nhvj                         1/1     Running              0          11h
#collectd-dgtpm                         1/1     Running              1          13h
#prometheus-inst-0                      3/3     Running              4          13h
#prometheus-operator-57f98cf8bd-kbcl2   1/1     Running              1          13h
#prometheus-adapter-64ff5596dd-nlrr7    1/1     Running              1          13h
#collectd-f9q5g                         1/1     Running              0          101s


kubectl get all

