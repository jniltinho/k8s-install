#!/bin/bash
## Install Minikube on Ubuntu 18.04 64Bits
## Author: Nilton Oliveira
## https://kubernetes.io/docs/setup/
## https://minikube.sigs.k8s.io/

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


curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl
install kubectl /usr/local/bin/kubectl


curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube

## minikube start --kubernetes-version=v1.15.0
minikube start --kubernetes-version=v1.15.0 --vm-driver=none --apiserver-ips 127.0.0.1 --apiserver-name localhost


kubectl get po -A
minikube dashboard

kubectl run hello-nginx --image=index.docker.io/nginx:1.14.0 --port=80
kubectl expose deployment hello-nginx --type=NodePort
minikube service hello-nginx
