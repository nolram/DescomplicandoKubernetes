#!/bin/bash

echo "Install Docker Engine..."
apt-get update
apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "Add vagrant user to docker group"
usermod -aG docker vagrant

echo "Show containers..."
docker container ls

echo "Configure container runtime deamon by EOF (End Of File)..."
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

echo "Create docker service for systemd..."
mkdir -p /etc/systemd/system/docker.service.d

echo "reload daemon..."
systemctl daemon-reload

echo "Restart docker..."
systemctl restart docker

echo "Check cgroup in docker info..."
docker info | grep -i cgroup

echo "Removing config.toml containerd"
# https://github.com/containerd/containerd/issues/4581
rm /etc/containerd/config.toml
systemctl restart containerd