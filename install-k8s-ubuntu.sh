#!/bin/bash
## Install kubernetes 1.14.0 on Ubuntu 18.04 64Bits
## Author: Nilton Oliveira
## https://www.linuxtechi.com/install-configure-kubernetes-ubuntu-18-04-ubuntu-18-10/
## https://www.learnitguide.net/2018/08/install-and-configure-kubernetes-cluster.html
## https://www.ostechnix.com/how-to-configure-ip-address-in-ubuntu-18-04-lts/
## https://kubernetes.io/docs/setup/independent/install-kubeadm/
## https://www.howtoforge.com/tutorial/how-to-install-kubernetes-on-ubuntu/
## https://github.com/kubernetes/dashboard
## https://kubernetes.github.io/ingress-nginx/deploy/

## 1 Server Master: Ubuntu 18.04, 2CPUs, 2GB RAM, 20GB HD, 64bits
## 1 Server Node1: Ubuntu 18.04, 2CPUs, 4GB RAM, 20GB HD, 64bits
## 1 Server Node2: Ubuntu 18.04, 2CPUs, 4GB RAM, 20GB HD, 64bits

## Install Docker
apt-get update && apt-get upgrade -y
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


## Disable SWAP, disable in /etc/fstab
## sed -i '/ swap / s/^/#/' /etc/fstab
swapon -s && swapoff -a
sed -i 's/.*swap.*/#&/' /etc/fstab


## Install Kubadm
CNI_VERSION="v0.8.2"
mkdir -p /opt/cni/bin
curl -L "https://github.com/containernetworking/plugins/releases/download/${CNI_VERSION}/cni-plugins-linux-amd64-${CNI_VERSION}.tgz" | tar -C /opt/cni/bin -xz

CRICTL_VERSION="v1.14.0"
mkdir -p /opt/bin
curl -L "https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz" | tar -C /opt/bin -xz


RELEASE="v1.14.0"
mkdir -p /opt/bin
cd /opt/bin
curl -L --remote-name-all https://storage.googleapis.com/kubernetes-release/release/${RELEASE}/bin/linux/amd64/{kubeadm,kubelet,kubectl}
chmod +x {kubeadm,kubelet,kubectl}

curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/kubelet.service" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service
mkdir -p /etc/systemd/system/kubelet.service.d
curl -sSL "https://raw.githubusercontent.com/kubernetes/kubernetes/${RELEASE}/build/debs/10-kubeadm.conf" | sed "s:/usr/bin:/opt/bin:g" > /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

ln -s /opt/bin/{kubeadm,kubectl,kubelet} /usr/local/bin/
systemctl enable --now kubelet

## Master Server
kubeadm init --pod-network-cidr=172.16.0.0/16 --apiserver-advertise-address=$(hostname -I | awk '{print $1}')

### For AWS/Azure External IP/DNS
## kubeadm init --pod-network-cidr=172.16.0.0/16 --apiserver-advertise-address=$(hostname -I | awk '{print $1}') \ 
##  --apiserver-cert-extra-sans=10.132.207.117,k8s.mydomain.com

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

## Fix Helm install error
cd /tmp/
wget https://docs.projectcalico.org/v3.9/manifests/calico.yaml
sed -i 's|192.168.0.0/16|172.16.0.0/16|' calico.yaml
kubectl apply -f calico.yaml
rm -f calico.yaml


## Join in Nodes

