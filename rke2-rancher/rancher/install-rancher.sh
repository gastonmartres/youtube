#!/bin/bash
#=====[ INSTALL RANCHER ]=====
#
# A favor del laboratorio, vamos a instalar rancher desde el SERVER de RKE2.
# 
# ATENCION: Si recien se terminó de instalar RKE2,
# hay que dejar unos minutos hasta que termine de bajar
# todos los contenedores necesarios.
#

if [ ! -f /etc/rancher/rke2/rke2.yaml ];then
  echo "Please run this script after installing RKE2".
  exit 1
fi

if [ $USER != "root" ];then
  echo "Please run as root"
  exit 1
fi

export KUBECONFIG="/etc/rancher/rke2/rke2.yaml"
# FQDN es el mismo que configuramos en la instalacion de RKE2
FQDN=${FQDN:-"rancher.example.com"}

# Password que vamos a utilizar para loguear a rancher.
RANCHERPASS=${RANCHERPASS:-"changeme"}

# Instalamos kubectl
echo "[ Installing kubectl ]"
curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Instalamos Helm
echo "[ Installing Helm ]"
curl -sLO https://get.helm.sh/helm-$(curl -L -s https://get.helm.sh/helm-latest-version)-linux-amd64.tar.gz
tar zxvf helm-*-linux-amd64.tar.gz
sudo install -o root -g root -m 0755 linux-amd64/helm /usr/local/bin/helm

# Agregamos el repositorio de rancher.
echo "... Adding rancher-stable repo to Helm..."
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable

# Creamos el namespace
echo "... Creating cattle-system namespace for rancher..."
kubectl --kubeconfig=/etc/rancher/rke2/rke2.yaml create namespace cattle-system

# Instalamos cert-manager
echo "... Installing cert-manager..."
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
echo "[ Installing Rancher ]"
helm install rancher rancher-stable/rancher \
  --namespace cattle-system \
  --set hostname=${FQDN} \
  --set bootstrapPassword=${RANCHERPASS} \
  --set global.cattle.psp.enabled=false