#!/bin/bash
## Install HELM on k8s 1.14.0
## Author: Nilton Oliveira
## Run Master k8s Server

curl -L https://git.io/get_helm.sh | bash
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller