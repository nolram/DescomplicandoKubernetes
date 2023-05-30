CRIO_OS='xUbuntu_22.04'
CRIO_VERSION='1.26'


echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$CRIO_OS/ /"|sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$CRIO_OS/ /"|sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list

curl -L http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$CRIO_OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$CRIO_OS/Release.key | sudo apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -

apt-get update
yes | sudo DEBIAN_FRONTEND=noninteractive apt-get -yqq install cri-o cri-o-runc cri-tools

systemctl daemon-reload
systemctl enable crio.service 
systemctl start crio.service 