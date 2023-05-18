#!/bin/bash

KUBERNETES_VERSION="1.27.1-00"

# Kubernetes config
echo "Add kubernetes repository..."
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - 
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt-get update
yes | sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq install kubeadm=$KUBERNETES_VERSION kubelet=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION
apt-mark hold kubelet kubeadm kubectl

# config locale
locale-gen pt_BR.UTF-8