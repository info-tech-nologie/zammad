#!/bin/bash
set -e

echo "Mise à jour des paquets..."
sudo apt update && sudo apt upgrade -y

echo "Installation des outils de base..."
sudo apt install -y conntrack socat ebtables ethtool

echo "Installation de Docker (si non présent)..."
if ! command -v docker &> /dev/null; then
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
      | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker
    sudo systemctl start docker
else
    echo "Docker déjà installé."
fi

echo "Installation de kubectl..."
if ! command -v kubectl &> /dev/null; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
else
    echo "kubectl déjà installé."
fi

echo "Installation de crictl..."
CRICTL_VERSION="v1.27.0"
if ! command -v crictl &> /dev/null; then
    curl -LO https://github.com/kubernetes-sigs/cri-tools/releases/download/${CRICTL_VERSION}/crictl-${CRICTL_VERSION}-linux-amd64.tar.gz
    sudo tar zxvf crictl-${CRICTL_VERSION}-linux-amd64.tar.gz -C /usr/local/bin
    rm crictl-${CRICTL_VERSION}-linux-amd64.tar.gz
else
    echo "crictl déjà installé."
fi

echo "Vérification des versions installées :"
kubectl version --client --short || true
crictl --version || true
conntrack --version || true
docker --version || true

echo "Installation terminée. Tu peux maintenant lancer :"
echo "sudo minikube start --driver=none --listen-address=0.0.0.0"

