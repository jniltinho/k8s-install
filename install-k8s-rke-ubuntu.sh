#!/bin/bash
## Install kubernetes 1.14.6 with rke on Ubuntu 18.04 64Bits
## Author: Nilton Oliveira
## https://medium.com/@marcoscordeirojr/instala%C3%A7%C3%A3o-de-cluster-rancher-com-alta-disponibilidade-91582482c4f0
## https://itnext.io/setup-a-basic-kubernetes-cluster-with-ease-using-rke-a5f3cc44f26f
## https://hackernoon.com/deploying-kubernetes-on-premise-with-rke-and-deploying-openfaas-on-it-part-1-69a35ddfa507
## https://rancher.com/docs/rancher/v2.x/en/installation/ha/kubernetes-rke/
## https://rancher.com/docs/rke/latest/en/managing-clusters/
## https://rancher.com/docs/rke/latest/en/installation/

wget https://github.com/rancher/rke/releases/download/v0.2.8/rke_linux-amd64 -O /usr/local/bin/rke
chmod +x /usr/local/bin/rke

### Criando o Config do Cluster
rke config --name cluster.yml

### Subindo o cluster
rke up


### Install kubectl
curl -L https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl
chmod +x /usr/local/bin/kubectl
export KUBECONFIG=$(pwd)/kube_config_cluster.yml

kubectl get no
kubectl get po -A
