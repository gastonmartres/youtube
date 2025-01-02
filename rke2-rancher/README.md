# Instalacion de RKE2 Server

El archivo de configuracion principal de rke2 es `config.yaml`.
En las siguientes lineas vamos a ver los distintos pasos y configuraciones que necesitamos para levantar nuestro cluster de **RKE2**.

## config.yaml

La ubicacion y el archivo de configuracion para rke2: 

```/etc/rancher/rke2/config.yaml```

## Token
Generar el token que vamos a usar en la configuracion:

```head -c 16 /dev/urandom | sha256sum | awk '{print $1}'```

Esto nos va a dar algo similar a lo siguiente:

```
$ head -c 16 /dev/urandom | sha256sum | awk '{print $1}'
dc6801605649f15ff5fae878c6b8b8c0b783590c92d24b033a211229981da82c
```
Copiamos la cadena de texto y la guardamos en algun editor de texto para usarla mas adelante.

## Configuración
Ejemplo del archivo config.yaml que utilizamos en el video, el que podemos abrir con `vim`, `nano`, o el editor que tengas a mano:

```
write-kubeconfig-mode: "0644"
etcd-snapshot-schedule-cron: "*/6 * * *"
etcd-snapshot-retention: 56
token: "dc6801605649f15ff5fae878c6b8b8c0b783590c92d24b033a211229981da82c"
tls-san:
  - "rancher.example.com"
cni: 
  - canal
```

Recordá reemplazar el token `dc6801605649f15ff5fae878c6b8b8c0b783590c92d24b033a211229981da82c` por el token que generaste en el paso anterior.

## Descargar rke2 e iniciar el servicio
Comando de curl para descargar el servidor de RKE2:

```curl -sfL https://get.rke2.io | sh -```

Si queremos instalar RKE2 en modo AGENTE:

```curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -```

Una vez que tenemos descargado **RKE2**, entonces iniciamos el servicio con el siguiente comando:

`systemctl enable --now rke2-server`

Tengan en cuenta que este proceso puede tardar bastante en funcion de la velocidad de internet, la maquina donde está corriendo, etc.


## Kubectl

Para poder administrar nuestro cluster de rke2/k8s vamos a necesitar una herramienta llamada `kubectl`.

Instalar el binario de *kubectl*:

```
curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

Una vez que terminamos de instalar el binario de `kubectl`, podemos hacer una pruebas basicas, pero primero debemos configurar la variable de entorno **KUBECONFIG**.
La variable de entorno **KUBECONFIG** se utiliza en Kubernetes para especificar la ubicación de uno o más archivos de configuración (normalmente llamados config) que contienen las credenciales y la información necesaria para acceder a un clúster.

Para esto vamos a hacer lo siguiente, ya sabiendo que el archivo que necesitamos se encuentra en `/etc/rancher/rke2/rke2.yaml`.
Este archivo se genera automaticamente al finalizar la instalacion de `rke2-server`.

```
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
```

Una vez que ya tenemos declarada la variable de entorno **KUBECONFIG**, entonces podemos hacer pruebas contra nuestro cluster.
El comando mas simple que podemos correr va a ser: 

`kubectl get nodes`

Este comando nos da como resultado un listado de nodos, que en nuestro caso será de uno solo:

```
vm-leap-rke2-01:~ # kubectl get nodes
NAME              STATUS   ROLES                       AGE   VERSION
vm-leap-rke2-01   Ready    control-plane,etcd,master   14d   v1.30.7+rke2r1
```

Tambien podriamos ver los pods que están corriendo en el cluster con el comando:

`kubectl get pods -A`

Cuidado con el modificacion `-A` en un cluster con muchos pods corriendo, ya que trae todos los pods, no solo los del `namespace` actual.

Un ejemplo del comando seria el siguiente:

```
vm-leap-rke2-01:~ # kubectl get pods -A
NAMESPACE     NAME                                                   READY   STATUS      RESTARTS       AGE
kube-system   cloud-controller-manager-vm-leap-rke2-01               1/1     Running     2 (98s ago)    14d
kube-system   etcd-vm-leap-rke2-01                                   1/1     Running     1              14d
kube-system   helm-install-rke2-canal-bthmt                          0/1     Completed   0              14d
kube-system   helm-install-rke2-coredns-6mwk9                        0/1     Completed   0              14d
kube-system   helm-install-rke2-ingress-nginx-c8kqr                  0/1     Completed   0              14d
kube-system   helm-install-rke2-metrics-server-q9jkh                 0/1     Completed   0              14d
kube-system   helm-install-rke2-snapshot-controller-crd-fqtv9        0/1     Completed   0              14d
kube-system   helm-install-rke2-snapshot-controller-n87h8            0/1     Completed   1              14d
kube-system   helm-install-rke2-snapshot-validation-webhook-k78xd    0/1     Completed   0              14d
kube-system   kube-apiserver-vm-leap-rke2-01                         1/1     Running     3              14d
kube-system   kube-controller-manager-vm-leap-rke2-01                1/1     Running     2 (97s ago)    14d
kube-system   kube-proxy-vm-leap-rke2-01                             1/1     Running     1 (104s ago)   14d
kube-system   kube-scheduler-vm-leap-rke2-01                         1/1     Running     1 (104s ago)   14d
kube-system   rke2-canal-nft4l                                       2/2     Running     2 (104s ago)   14d
kube-system   rke2-coredns-rke2-coredns-867d6d5c55-jpgjg             1/1     Running     1 (104s ago)   14d
kube-system   rke2-coredns-rke2-coredns-autoscaler-54cfb678f-s77vd   1/1     Running     1 (104s ago)   14d
kube-system   rke2-ingress-nginx-controller-8bk8k                    1/1     Running     1 (104s ago)   14d
kube-system   rke2-metrics-server-75866c5bb5-t6f62                   1/1     Running     1 (104s ago)   14d
kube-system   rke2-snapshot-controller-577cdd5b98-zhjhm              1/1     Running     1 (104s ago)   14d
kube-system   rke2-snapshot-validation-webhook-855f5f7d76-kvswf      1/1     Running     1 (104s ago)   14d
```
