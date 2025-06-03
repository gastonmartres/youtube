# Ansible RKE2 + Rancher + NFS Deployment

Este proyecto automatiza la instalación de un clúster RKE2 (3 servidor + 2 workers) y la instalación de Rancher, incluyendo un servidor NFS opcional para almacenamiento compartido.

---

## 📦 Estructura del inventario

Editá el archivo `inventory` para definir tus hosts:

```ini
[rke2_server]
192.168.0.71

[rke2_node]
192.168.0.72
192.168.0.73

[rke2_agent]
192.168.0.74
192.168.0.75

[nfs_server]
192.168.0.80

[all:vars]
ansible_user=root
ansible_ssh_private_key_file=~/.ssh/id_rsa
ansible_python_interpreter=/usr/bin/python3
```

---

## 📁 Variables globales

En `group_vars/all.yml` podés definir:

- `fqdn`: Nombre del host para Rancher (por defecto: `rancher.secura.net.ar`)
- `server_ip`: IP del nodo server RKE2
- `rancher_pass`: Password de bootstrap para Rancher (por defecto: `changeme`)

---

## 🚀 Ejecución por pasos

### 1. Instalar solo el nodo **RKE2 Server** (generará token y kubeconfig)

```bash
ansible-playbook -i inventory playbook.yml -l rke2_server
```

### 2. Instalar los **nodos**

```bash
ansible-playbook -i inventory playbook.yml -l rke2_node
```

### 3. Instalar los **nodos Workers**

```bash
ansible-playbook -i inventory playbook.yml -l rke2_agent
```

### 4. Instalar **Rancher**

```bash
ansible-playbook -i inventory playbook.yml --tags rancher -l rke2_server
```

### 5. (Opcional) Instalar servidor **NFS**

```bash
ansible-playbook -i inventory playbook.yml -l nfs_server
```

---

## 🔖 Tags disponibles

Podés usar `--tags` para ejecutar partes del playbook:

- `common`
- `rke2_server`
- `rke2_node`
- `rke2_agent`
- `rancher`
- `nfs_server`

---

## 🛠 Requisitos

- Ansible instalado
- Conexión SSH con clave a los nodos
- Python 3 en los hosts
- Acceso sudo/root habilitado