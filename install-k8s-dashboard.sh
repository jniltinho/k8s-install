#!/bin/bash
## Install Kubernetes Dashboard on k8s 1.14.0
## Author: Nilton Oliveira
## Run Master k8s Server


kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl create namespace kubernetes-dashboard

kubectl apply -f yaml_k8s/dashboard-adminuser.yaml
kubectl -n kubernetes-dashboard describe secret $(kubectl -n kubernetes-dashboard get secret | grep admin-user | awk '{print $1}')
