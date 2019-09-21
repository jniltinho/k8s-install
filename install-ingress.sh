#!/bin/bash
## Install Ingress Nginx on k8s 1.14.0
## Author: Nilton Oliveira
## Run Master k8s Server


## Ingress Nginx
## https://kubernetes.github.io/ingress-nginx/deploy/

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud-generic.yaml