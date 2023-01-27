# Instalar Docker en Almalinux/CentOS


## Primeros Pasos
Esta guía pretende que puedas instalar **Docker** en **Almalinux 8** de la manera mas simple posible.

Elegimos la versión **8** de **Almalinux**, ya que es la version mas estable y compatible con la que hubiese sido **CentOS 8**.

### Actualizar Sistema
Lo primero que debemos hacer, como una buena practica, es actualizar nuestro sistema:

    sudo dnf -y --refresh update

    sudo dnf -y upgrade

Una vez que tenemos nuestro sistema en la ultima versión, entonces ahí si podemos continuar.

### Agregar el repositorio de Docker

Para agregar el repositorio oficial de **Docker** debemos seguir los siguientes pasos:

Instalamos los paquetes necesarios:

    sudo dnf install -y yum-utils

Ahora si, agregamos la entrada al repositorio propiamente dicho:

    sudo yum-config-manager -y --add-repo https://download.docker.com/linux/centos/docker-ce.repo

### Instalamos Docker

Una vez que ya tenemos actualizado el sistema y agregado el repositorio, entonces si, podemos empezar con la instalación de **Docker**:

    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

### Habilitamos Docker en el sistema

Generalmente no es necesario este paso, pero si llegara a ser necesario, podemos hacer lo siguiente:

Iniciamos el demonio de **Docker**:

    sudo systemctl start docker

Habilitamos que se ejecute automáticamente cada vez que inicia el sistema:

    sudo systemctl enable docker

Y chequeamos el estado del servicio:

    sudo systemctl status docker

### Habilitamos nuestro usuario para ejecutar Docker

Cuando recién instalamos **Docker** en nuestro sistema, podemos observar que para poder correr comandos en **Docker** debemos anteponer `sudo`, algo que es un poco molesto y no muy seguro.

Entonces lo que vamos a hacer es darle a nuestro usuario la capacidad de correr **Docker** sin necesidad de utilizar el comando `sudo`.

Para eso solo debemos agregar a nuestro usuario al grupo `docker` con el siguiente comando:

    sudo usermod -aG docker ${USER}

Y luego para probar que nuestro usuario puede ejecutar **Docker** sin problemas, hacemos lo siguiente:

	su - ${USER}
	docker run hello-world