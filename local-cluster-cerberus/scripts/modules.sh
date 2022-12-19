
echo "Update System"
apt-get update
apt-get upgrade -y
apt-get install net-tools apt-transport-https ca-certificates curl -y


# Enable kernel modules
echo "Enable kernel moludes..."
swapoff -a

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
br_netfilter
ip_vs_rr
ip_vs_wrr
ip_vs_sh
nf_conntrack_ipv4
ip_vs
EOF

modprobe br_netfilter ip_vs_rr ip_vs_wrr ip_vs_sh nf_conntrack_ipv4 ip_vs

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

# Atualiza parâmetros sem precisar reiniciar
sudo sysctl --system