#!/bin/bash
## Install Rancher on Ubuntu 18.04 64Bits
## Author: Nilton Oliveira


## 1 Server Master: Ubuntu 18.04, 2CPUs, 2GB RAM, 20GB HD, 64bits
## 1 Server Node1: Ubuntu 18.04, 2CPUs, 4GB RAM, 20GB HD, 64bits

## Install Docker
apt-get update && apt-get upgrade -y
apt-get -y install apt-transport-https ca-certificates curl software-properties-common docker.io socat

# Restart Docker
systemctl enable docker
systemctl restart docker

## Disable SWAP, disable in /etc/fstab
## sed -i '/ swap / s/^/#/' /etc/fstab
swapon -s && swapoff -a
sed -i 's/.*swap.*/#&/' /etc/fstab


mkdir -p /opt/rancher
docker run -d --restart=unless-stopped -p 8585:80 -p 8443:443 -v /opt/rancher:/var/lib/rancher rancher/rancher:latest


## Limpar o Ambiente
# docker stop $(docker ps -a -q)
# docker rmi -f $(docker images -q)
# docker rm -f $(docker ps -qa)
# docker volume rm $(docker volume ls -q)
# cleanupdirs="/opt/rancher /var/lib/etcd /var/lib/rancher /etc/kubernetes /etc/cni /opt/cni /var/lib/cni /var/run/calico /opt/rke /var/log/containers" 
# for dir in $cleanupdirs; do rm -rf $dir; done
