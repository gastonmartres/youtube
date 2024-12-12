#!/bin/bash
#=====[ INSTALL RANCHER ]=====
#
# La instalacion de rancher se debe hacer desde un host que tenga kubectl y helm instalado
#

if [ ! -f /etc/rancher/rke2/rke2.yaml ];then
    echo "Please run this after installing RKE2".
    exit 1
fi
export KUBECONFIG="/etc/rancher/rke2/rke2.yaml"
# FQDN es el mismo que configuramos en la instalacion de RKE2
FQDN="rancher.example.com"

# Password que vamos a utilizar para loguear a rancher.
KUBEPASS="changeme"

# Instalamos kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Instalamos Helm
curl -LO https://get.helm.sh/helm-$(curl -L -s https://get.helm.sh/helm-latest-version)-linux-amd64.tar.gz
tar zxvf helm-*-linux-amd64.tar.gz
sudo install -o root -g root -m 0755 linux-amd64/helm /usr/local/bin/helm

# Agregamos el repositorio de rancher.
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

# Creamos el namespace
kubectl --kubeconfig=/etc/rancher/rke2/rke2.yaml create namespace cattle-system

# Instalamos cert-manager
kubectl --kubeconfig=/etc/rancher/rke2/rke2.yaml  apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.2/cert-manager.crds.yaml
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.16.2

# Chequeamos como viene la mano
kubectl  --kubeconfig=/etc/rancher/rke2/rke2.yaml  get pods --namespace cert-manager

# Instalamos rancher
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=${FQDN} \
  --set bootstrapPassword=${KUBEPASS} \
  --set global.cattle.psp.enabled=false