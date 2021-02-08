SHELL=/bin/bash

CA_KEY?=ca.key
CA_CRT?=ca.crt

ROS_SUBJECT=ros-svc.kube-system.svc
ROS_SAN=DNS:ros-svc.kube-system, DNS:ros-svc.kube-system.svc, IP:10.43.0.255, IP:10.96.0.255

PROMETHEUS_SUBJECT=prometheus-svc.default.svc
PROMETHEUS_SAN=DNS:prometheus-svc.default.svc, DNS:prometheus-svc.default.svc.cluster.local, DNS:prometheus-svc.default

ADAPTER_SUBJECT=prometheus-adapter.default.svc.cluster.local
ADAPTER_SAN=DNS:prometheus-adapter.default.svc.cluster.local, DNS:prometheus-adapter.default.svc, DNS:prometheus-adapter.default

COLLECTD_SUBJECT=collectd-svc.default.svc.cluster.local
COLLECTD_SAN=DNS:*.collectd-svc.default.svc.cluster.local


.SUFFIXES: .key .csr .crt .pem
.PRECIOUS: %.key %.csr %.crt %.pem

.PHONY: default
default: ROS.crt ADAPTER.crt PROMETHEUS.crt COLLECTD.crt

$(CA_KEY) $(CA_CRT):
	@echo "Generating CA..."
	@openssl req -x509 -sha384 -new -nodes -days 365 -newkey rsa:4096 -keyout $(CA_KEY) -out $(CA_CRT) -subj "/C=SG/ST=SG/O=MyOrg, Inc./CN=ca";


%.key:
	@echo "Generating server key..."
	@openssl genrsa -out $@ 4096;


%.csr: %.key
	@echo $($(basename $<)_SAN)
	@echo "Generating server csr..."
	@openssl req -new -sha384 \
	-key $< \
	-subj "/C=SG/ST=SG/O=MyOrg, Inc./CN=$($(basename $<)_SUBJECT)" \
	-reqexts SAN \
	-config <(cat /etc/ssl/openssl.cnf <(printf "\n[SAN]\nsubjectAltName=$($(basename $<)_SAN)")) \
	-out $@

%.crt: %.key %.csr $(CA_CRT) $(CA_KEY)
	@echo "Generating server crt..."
	@openssl x509 -req \
	-extfile <(printf "subjectAltName=$($(basename $<)_SAN)") \
	-in $(word 2,$^) -CA $(CA_CRT) -CAkey $(CA_KEY) -CAcreateserial -out $@ -days 365 -sha384






