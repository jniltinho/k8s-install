#!/bin/bash
## Install HAProxy on Ubuntu 18.04 64Bits
## Author: Nilton Oliveira
## https://www.haproxy.com/documentation/aloha/10-0/traffic-management/lb-layer7/health-checks/

apt-get update
apt-get upgrade -y
apt-get -y install haproxy

echo 'listen rancher-web-app
  bind 192.168.100.7:80
  mode http
  option log-health-checks
  option tcplog
  http-request set-header X-Forwarded-Port %[dst_port]
  http-request add-header X-Forwarded-Proto https if { ssl_fc }
  option httpchk GET / HTTP/1.0
  http-check expect rstatus (3|4)[0-9][0-9]
  server kube-node02 192.168.100.5:80
  server kube-node03 192.168.100.6:80


listen stats
    bind *:9000
    mode http
    stats enable
    stats refresh 30s
    stats realm HAProxy
    stats auth admin:passwd
    stats uri  /haproxy
' >> /etc/haproxy/haproxy.cfg

## Checar a configuração
haproxy -c -f /etc/haproxy/haproxy.cfg

### Reiniciar o Serviço do HAproxy
service haproxy restart

## Stats do HAProxy
## http://<ip_haproxy>:9000/haproxy
