#!/bin/bash
# ========[ INSTALL RKE2 ]========
# Instalación RKE2 versión SERVER
#
# https://youtube.com/@gastonmartres
#

# FQDN o nombre dns desde el cual acceder a rancher.
FQDN="rancher.secura.net.ar"

# Actualizamos el sistema operativo
zypper refresh && zypper update

# Si estamos en una red propia, a las funciones de laboratorio
# deshabilitamos el firewall.
systemctl stop firewalld
systemctl disable firewalld

# Instalamos los paquetes necesarios
# Aca se instala open-vm-tools para VM en VMWare
# Para VM en Proxmox se puede instalar qemu-guest-agent.
zypper install -y docker open-vm-tools open-iscsi
systemctl enable --now docker

# Creamos el directorio donde residirá la configuracion de RKE2/Rancher
mkdir -p /etc/rancher/rke2

#[ SERVER ]
# Creamos el archivo de configuración que va a utilizar rke2-server
cat <<EOF | tee /etc/rancher/rke2/config.yaml
write-kubeconfig-mode: "0644"
etcd-snapshot-schedule-cron: "*/6 * * *"
etcd-snapshot-retention: 56
token: "66ae955cbc46dd1f8d672be858b5f015"
tls-san:
  - "${FQDN}"
cni: 
  - canal
EOF

# Bajamos la ultima version de RKE2 y lo ejecutamos
curl -sfL https://get.rke2.io | sh -

# Habilitamos el servicio de rke2-server y lo iniciamos.
systemctl enable --now rke2-server
