## QUE ES UN CONTENEDOR

Los contenedores son una forma de virtualización que aprovecha el kernel del sistema operativo subyacente, sin tener la necesidad de virtualizar una maquina completa.

Bajo un contenedor se puede ejecutar prácticamente cualquier cosa: aplicaciones, microservicios, procesos, etc.

Dentro de cada contenedor vamos a encontrar una versión reducida del sistema operativo en el que se basa dicho contenedor, ademas de las herramientas y/o aplicaciones que deseamos ejecutar.

Por ejemplo, si lo que queremos ejecutar es un servidor web, seguramente vamos a encontrar una copia de nginx o apache, el cual va a servir el contenido que le digamos, utilizando varios métodos de almacenamiento.

Todo eso se puede realizar utilizando imágenes base.


## Variantes

Docker, Podman, Cri-o, LXD

## Que es una imágen base

Una imagen base de contenedores es el template o plantilla que vamos a usar como punto de partida para poder ejecutar nuestro contenedor.

Generalmente vamos a utilizar una registry de imágenes para poder hacer `pull` (bajar) de esa imagen y modificarla de manera local, y así poder agregar la información que necesitemos.

Una de las registries mas conocida es la de Dockerhub, donde podemos encontrar prácticamente cualquier imagen que necesitemos. [https://hub.docker.com](https://hub.docker.com)

Hay que tener en cuenta que las imágenes base son inmutables. Esto quiere decir que no podemos modificarlas como un archivo, sino que vamos a ir agregando la información, archivos, configuraciones, etc, como capas.

Estas capas o layers son las que van a ser agregadas al contenedor cuando vayamos a ejecutarlo y las mismas van a contener configuraciones, variables, archivos, etc.

La ventaja de usar capas es que, cuando hacemos una modificación a dicha capa, solo se ve afectada esa capa y no todo el resto del contenedor, por lo que actualizar el contenedor es relativamente rápido y simple.

## Cuales son las ventajas de utilizar contenedores

Las ventajas son muchas en comparación a utilizar VM tradicionales:

- **Menor carga**: se requieren menos recursos para ejecutar que una VM
- **Portabilidad**: si funciona en una maquina, funciona en otra, independiente del hardware y el sistema operativo.
- **Actualizables**: es mas fácil actualizar un contenedor que todo un sistema operativo completo.
- **Eficientes**: le da al desarrollador, devop, sre, etc un entorno seguro y practico para desarrollar o probar software.

## Como creamos un contenedor

La forma correcta de crear un contenedor seria utilizando un archivo `Dockerfile`.

En este archivo declaramos los pasos necesarios para crear un contenedor y el mismo puede contener, por ejemplo, la declaración de variables, la imagen base que vamos a utilizar, el comando a ejecutar una vez que ejecutamos el contenedor.

Veamos solo un ejemplo de un archivo `Dockerfile`:

```
FROM httpd:alpine3.17
ENV MYVAR supercalifragilistico
COPY index.html /usr/local/apache2/htdocs/
```

En este ejemplo vemos lo siguiente:

**FROM**: nombre de la imagen base que vamos a utilizar
**ENV**: indicamos que vamos a utilizar una variable de entorno que se llama **MYVAR** y que su contenido es **supercalifragilistico**.
**COPY**: copiamos el archivo `index.html` a la carpeta `/usr/local/apache2/htdocs/` dentro del contenedor.

Más adelante vamos a poder practicar mejor lo que estamos viendo en este ejemplo.