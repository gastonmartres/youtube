# Instalar Docker en Ubuntu 22.04

## Primeros Pasos
Esta guia pretende que puedas instalar **Docker** en **Ubuntu 22.04** de la manera mas simple posible.

Elegimos la versión **22.04** de **Ubuntu**, ya que cuenta con soporte **LTS** o **Long Term Support**, por lo que tiene soporte extendido por varios años, en comparacion con versiones del estilo 22.10, que solo tiene soporte de 1 año.

### Actualizar Sistema

Lo primero que debemos hacer, como una buena practica, es actualizar nuestro sistema:

	sudo apt update -y && sudo apt upgrade -y

Una vez que tenemos nuestro sistema en la ultima versión, entonces ahí si podemos continuar.

### Agregar el repositorio de Docker

Para agregar el repositorio oficial de **Docker** debemos seguir los siguientes pasos:

Instalamos los paquetes necesarios:

	sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
	
Instalamos la llave **PGP** utilizada para firmar los paquetes:

	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
	
Ahora si, agregamos la entrada al repositorio propiamente dicho:

	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

Una vez que agregemos el repositorio, actualizamos el indice de paquetes del sistema.
  
	sudo apt update

### Instalamos Docker

Una vez que ya tenemos actualizado el sistema y agregado el repositorio, entonces si, podemos empezar con la instalacion de **Docker**:

	sudo apt install -y docker-ce

### Habilitamos Docker en el sistema

Generalmente no es necesario este paso, pero si llegara a ser necesario, podemos hacer lo siguiente:

Iniciamos el demonio de **Docker**:

	sudo systemctl start docker

Habilitamos que se ejecute automaticamente cada vez que inicia el sistema:

	sudo systemctl enable docker

Y vemos el estado:

	sudo systemctl status docker

### Habilitamos nuestro usuario para ejecutar Docker

Cuando recien instalamos **Docker** en nuestro sistema, podemos observar que para poder correr comandos en **Docker** debemos anteponer `sudo`, algo que es un poco molesto y no muy seguro.

Entonces lo que vamos a hacer es darle a nuestro usuario la capacidad de correr **Docker** sin necesidad de utilizar el comando `sudo`.

Para eso solo debemos agregar a nuestro usuario al grupo `docker` con el siguiente comando:

	sudo usermod -aG docker ${USER}

Y luego para probar que nuestro usuario puede ejecutar **Docker** sin problemas, hacemos lo siguiente:

	su - ${USER}
	docker run hello-world
