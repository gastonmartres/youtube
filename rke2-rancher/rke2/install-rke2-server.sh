#!/bin/bash
# ========[ INSTALL RKE2 ]========
# Instalación RKE2 versión SERVER
#
# https://youtube.com/@gastonmartres
#

# FQDN o nombre dns desde el cual acceder a rancher.
FQDN=${FQDN:-"rancher.example.com"}

# Actualizamos el sistema operativo
zypper refresh && zypper update -y

# Si estamos en una red propia, a las funciones de laboratorio
# deshabilitamos el firewall.
systemctl stop firewalld
systemctl disable firewalld

# Instalamos los paquetes necesarios.
# Aca se instala open-vm-tools para VM en VMWare
# Para VM en Proxmox se puede instalar qemu-guest-agent.
zypper install -y docker open-vm-tools open-iscsi
systemctl enable --now docker

# Creamos el directorio donde residirá la configuracion de RKE2/Rancher
mkdir -p /etc/rancher/rke2

# Generamos un token random para usar en el archivo config.yaml
TOKEN=$(head -c 16 /dev/urandom | sha256sum | awk '{print $1}' | cut -b 1-32)
echo "Please write it down in a safe place. You will need this token when adding AGENTS and NODES."
echo "---------------------------------------"
echo "...Token: ${TOKEN}"
echo "---------------------------------------"
echo $TOKEN > /etc/rancher/rke2/rke2-token.txt

#[ SERVER ]
# Creamos el archivo de configuración que va a utilizar rke2-server
cat <<EOF | tee /etc/rancher/rke2/config.yaml
write-kubeconfig-mode: "0644"
etcd-snapshot-schedule-cron: "*/6 * * *"
etcd-snapshot-retention: 56
token: "${TOKEN}"
tls-san:
  - "${FQDN}"
cni: 
  - canal
EOF

# Bajamos la ultima version de RKE2 y lo ejecutamos
curl -sfL https://get.rke2.io | sh -

# Habilitamos el servicio de rke2-server y lo iniciamos.
systemctl enable --now rke2-server

# Instalamos kubectl
echo "[ Installing kubectl ]"
curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl