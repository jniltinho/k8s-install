#!/bin/bash
## Install Rancher on Ubuntu 18.04 64Bits
## Author: Nilton Oliveira


## 1 Server Master: Ubuntu 18.04, 2CPUs, 2GB RAM, 20GB HD, 64bits
## 1 Server Node1: Ubuntu 18.04, 2CPUs, 4GB RAM, 20GB HD, 64bits

## Install Docker
apt-get update && apt-get upgrade
apt-get -y install apt-transport-https ca-certificates curl software-properties-common docker.io socat

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

# Restart Docker
mkdir -p /etc/systemd/system/docker.service.d
systemctl daemon-reload && systemctl enable docker && systemctl restart docker


mkdir -p /var/nfs/rancher
docker run -d --restart=unless-stopped -p 8585:80 -p 8443:443 -v /var/nfs/rancher:/var/lib/rancher rancher/rancher:latest
