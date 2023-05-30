#!/bin/bash

USER_HOME=/home/vagrant

echo "Download images of the components by cluster..."
kubeadm config images pull

echo "Initialize cluster..."
mkdir -p $USER_HOME/token
kubeadm init --apiserver-advertise-address 192.168.56.10 --pod-network-cidr 10.244.0.0/16 > $USER_HOME/token/.token_join

echo "configure runtime container for root..."
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo "configure runtime container for normal user..."
mkdir -p $USER_HOME/.kube
cp -i /etc/kubernetes/admin.conf $USER_HOME/.kube/config
chown vagrant:vagrant $USER_HOME/.kube/config

echo "Sleep 10 seconds"
sleep 10

source /var/lib/kubelet/kubeadm-flags.env
echo "KUBELET_KUBEADM_ARGS=\"$KUBELET_KUBEADM_ARGS --node-ip=$HOST_IP\"" > /var/lib/kubelet/kubeadm-flags.env

systemctl daemon-reload
systemctl restart kubelet

echo "Sleep 10 seconds"
sleep 10
# calico
echo "Should now deploy a pod network to the cluster..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.1/manifests/calico.yaml


# echo "List Nodes..."
# kubectl get nodes
# 
# # Firewall Allow
# ufw allow from 192.168.99.0/24
# ufw allow from 192.168.0.0/24
# 
# ufw allow from 192.168.99.0/24 to any port 6443
# ufw allow from 192.168.99.0/24 to any port 2379
# ufw allow from 192.168.99.0/24 to any port 2380
# ufw allow from 192.168.99.0/24 to any port 68
# 
# 
# ufw allow from 192.168.0.0/24 to any port 6443
# ufw allow from 192.168.0.0/24 to any port 2379
# ufw allow from 192.168.0.0/24 to any port 2380
# ufw allow from 192.168.0.0/24 to any port 68
# 
# ufw enable
# ufw reload
# 
echo "Show join token"
echo "========================================================================="
JOIN_TOKEN=$(cat token/.token_join |grep -i "kubeadm join" && cat token/.token_join |grep -i "discovery-token-ca-cert-hash")
SCRIPT_ARGS=$(cat <<-END
sleep 10
source /var/lib/kubelet/kubeadm-flags.env
echo "KUBELET_KUBEADM_ARGS=\\"\$KUBELET_KUBEADM_ARGS --node-ip=\$HOST_IP\\"" > /var/lib/kubelet/kubeadm-flags.env
systemctl daemon-reload
systemctl restart kubelet
END
)

SCRIPT_K8S=$(cat <<-END

$JOIN_TOKEN

$SCRIPT_ARGS
END
)

echo "$SCRIPT_K8S" > token/.token_join
cat token/.token_join
echo "========================================================================="

