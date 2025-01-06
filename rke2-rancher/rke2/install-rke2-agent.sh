#!/bin/bash
# ========[ INSTALL RKE2 ]========
# Instalación RKE2 versión AGENT
#
# https://youtube.com/@gastonmartres
#

# FQDN o nombre dns desde el cual acceder a rancher.
FQDN=${FQDN:-"rancher.example.com"}

# Reemplazar por la IP del SERVER
SERVERIP=${SERVERIP:-"0.0.0.0"}
if [ -z ${SERVERIP} ] || [ ${SERVERIP} == "0.0.0.0" ];then
  echo "Please define a valid SERVERIP value."
  exit 1
fi

# Reemplazar por el token generado con install-rke2-server.sh
TOKEN=${TOKEN:-"change-my-token"}

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

#[ SERVER ]
# Creamos el archivo de configuración que va a utilizar rke2-server
cat <<EOF | tee /etc/rancher/rke2/config.yaml
server: https://${SERVERIP}:9345
write-kubeconfig-mode: "0644"
token: "${TOKEN}"
tls-san:
  - "${FQDN}"
EOF

# Bajamos la ultima version de RKE2 y lo ejecutamos
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -

# Habilitamos el servicio de rke2-agent y lo iniciamos.
systemctl enable --now rke2-agent