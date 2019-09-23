#!/bin/bash
## Install Minikube on Ubuntu 18.04 64Bits
## Author: Nilton Oliveira
## https://kubernetes.io/docs/setup/
## https://minikube.sigs.k8s.io/
## https://computingforgeeks.com/how-to-install-minikube-on-ubuntu-18-04/
## https://kubernetes.io/docs/setup/learning-environment/minikube/
## https://coreos.com/kubernetes/docs/1.0.6/index.html




curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.0/bin/linux/amd64/kubectl
install kubectl /usr/local/bin/kubectl


curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube

## minikube start --vm-driver=none

minikube start --kubernetes-version=v1.15.0
kubectl get po -A
minikube dashboard

kubectl run hello-minikube --image=k8s.gcr.io/echoserver:1.4 --port=8080
kubectl expose deployment hello-minikube --type=NodePort
minikube service hello-minikube