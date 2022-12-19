#!/bin/bash

# Kubernetes config
echo "Add kubernetes repository..."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - 
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubeadm=1.25.4-00 kubelet=1.25.4-00 kubectl=1.25.4-00
apt-mark hold kubelet kubeadm kubectl

# config locale
locale-gen pt_BR.UTF-8