# Instalación de RKE2 Server

El archivo de configuración principal de RKE2 es `config.yaml`.
En las siguientes líneas veremos los distintos pasos y configuraciones necesarios para desplegar nuestro clúster de **RKE2**.

## Archivo config.yaml

La ubicación del archivo de configuración para RKE2 es:

```
/etc/rancher/rke2/config.yaml
```

## Token

Generar el token que utilizaremos en la configuración:

```
head -c 16 /dev/urandom | sha256sum | awk '{print $1}'
```

Este comando nos dará un resultado similar al siguiente:

```
$ head -c 16 /dev/urandom | sha256sum | awk '{print $1}'
dc6801605649f15ff5fae878c6b8b8c0b783590c92d24b033a211229981da82c
```

Copiamos la cadena de texto y la guardamos en un editor para utilizarla más adelante.

## Configuración

Ejemplo del archivo config.yaml utilizado en el video. Se puede editar con `vim`, `nano` o cualquier editor de texto disponible:

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

Recuerda reemplazar el token `dc6801605649f15ff5fae878c6b8b8c0b783590c92d24b033a211229981da82c` por el token generado en el paso anterior.

## Descargar RKE2 e iniciar el servicio

Comando de curl para descargar el servidor de RKE2:

```
curl -sfL https://get.rke2.io | sh -
```

Para instalar RKE2 en modo AGENTE:

```
curl -sfL https://get.rke2.io | INSTALL_RKE2_TYPE="agent" sh -
```

Una vez descargado **RKE2**, iniciamos el servicio con el siguiente comando:

```
systemctl enable --now rke2-server
```

Nota: Este proceso puede tardar dependiendo de la velocidad de internet y el rendimiento de la máquina.

## Kubectl

Para administrar nuestro clúster de RKE2/Kubernetes necesitaremos la herramienta `kubectl`.

Instalar el binario de *kubectl*:

```
curl -sLO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

Una vez instalado el binario, debemos configurar la variable de entorno **KUBECONFIG**.

La variable **KUBECONFIG** se utiliza en Kubernetes para especificar la ubicación de archivos de configuración que contienen las credenciales e información necesarias para acceder al clúster.

Sabemos que el archivo necesario se encuentra en:

```
/etc/rancher/rke2/rke2.yaml
```

Este archivo se genera automáticamente al finalizar la instalación de `rke2-server`.

Configuramos la variable de entorno:

```
export KUBECONFIG=/etc/rancher/rke2/rke2.yaml
```

Ahora podemos realizar pruebas contra nuestro clúster. Por ejemplo:

```
kubectl get nodes
```

Este comando mostrará la lista de nodos. En nuestro caso será uno solo:

```
vm-leap-rke2-01:~ # kubectl get nodes
NAME              STATUS   ROLES                       AGE   VERSION
vm-leap-rke2-01   Ready    control-plane,etcd,master   14d   v1.30.7+rke2r1
```

También podemos listar los pods en ejecución:

```
kubectl get pods -A
```

Nota: El modificador `-A` muestra todos los pods en todos los namespaces, lo cual puede generar una lista extensa si el clúster tiene muchos pods en ejecución.

Ejemplo:

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

# Agregar un nodo Agente de RKE2

Hay que tener en cuenta que hay una diferencia entre Nodo Server y Nodo Agente en lo que respecta RKE2.

Si vamos a agregar un Nodo Server, entonces hacemos que sea parte del plano de control (Control Plane) y tiene las siguientes caracteristicas:

### Nodo Server
* Administra el estado del clúster y realiza tareas de control.
* Aloja los componentes del plano de control, como:
    * API Server: Gestiona las solicitudes de la API.
    * Controller Manager: Mantiene el estado deseado de los recursos.
    * Scheduler: Asigna cargas de trabajo (pods) a los nodos disponibles.
    * Etcd: Base de datos distribuida que almacena el estado del clúster.

### Nodo Agente
Un agente en RKE2 se refiere específicamente al nodo de trabajo (worker). Es un nodo que:

* No aloja el plano de control.
* Se conecta al nodo de control para recibir instrucciones.
* Solo ejecuta aplicaciones en contenedores (pods) y gestiona la comunicación de red.

### Resumen de Diferencias
|Función	| Nodo de Control (Server)| Agente (Worker)|
|-----------|:-----------------------:|:--------------:|
|Rol principal	| Gestionar el estado del clúster.	| Ejecutar cargas de trabajo (pods).| 
|Componentes	| Plano de control (API Server, etcd).	| Kubelet, container runtime, kube-proxy.|
|Almacena estado?	| Sí, a través de etcd.	| No almacena el estado.| 
|Responsabilidad	| Administración y orquestación.| 	Ejecución de aplicaciones.|


## Archivo de Configuracion

Asi como utilizamos un archivo de configuracion en el Nodo Server, para los Agentes vamos a utilizar un archivo de configuracion, en la misma ubicacion y nombre que el utilizado en el Nodo Server, pero con algunas diferencias:

Ej:
```
server: https://192.168.0.71:9345
write-kubeconfig-mode: "0644"
token: "dc6801605649f15ff5fae878c6b8b8c0b783590c92d24b033a211229981da82c"
tls-san:
  - "rancher.example.com"
```

Esta es una breve explicación del archivo de configuracion:

* `server`: El el nodo principal, basicamente el primer nodo que armamos en modo Server. Podemos utilizar una dirección IP o un nombre de DNS si es que tiene asignado uno.
* `write-kubeconfig-mode`: El modo octal o permisos que va a tener el archivo de configuración de kubernetes. 
* `token`: El token que configuramos en el primer Nodo lo vamos a utilizar acá. Sin este token, los agentes y nodos no se pueden unir al cluster.
* `tls-san`: Nombres de dominio adicionales que se agregaran al certificado que utiliza RKE2.
* `node-label`: Etiqueta que le podemos asignar al Nodo. No es obligatorio, pero es útil para despues utilizarlo como `selector` en los manifiestos de k8s.

Una vez que tenemos el archivo de configuracion para el Agente, lo unico que nos queda es ejecutar el servicio:

`systemctl enable --now rke2-agent`

Tal cual como pasa con el Server, el proceso de inicio puede tardar unos minutos. Eso si, si está tardando mas de 5 minutos, entonces es posible que tengamos algun problema.
Para eso, deberia ingresar desde otra maquina y podemos ver los logs de lo que está pasando ejecutando:

`journalctl -xeu rke2-agent `

Esto nos va a mostrar las ultimas lineas del log de `rke2-agent` y nos puede ayudar a ver cual es el problema.

Este es un ejemplo de un cluster con varios nodos Agent:

```
vm-leap-rke2-01:~ # kubectl get nodes
NAME              STATUS   ROLES                       AGE   VERSION
vm-leap-rke2-01   Ready    control-plane,etcd,master   19h   v1.31.4+rke2r1
vm-leap-rke2-02   Ready    <none>                      19h   v1.31.4+rke2r1
vm-leap-rke2-03   Ready    <none>                      19h   v1.31.4+rke2r1
vm-leap-rke2-04   Ready    <none>                      19h   v1.31.4+rke2r1
vm-leap-rke2-05   Ready    <none>                      16h   v1.31.4+rke2r1
```

