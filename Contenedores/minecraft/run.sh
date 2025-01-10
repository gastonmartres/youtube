#!/bin/bash

# Nombre que le vamos a dar al contenedor
NAME=${NAME:-"rapid-rodent"}

# Imagen que vamos a utilizar para el contenedor. Debe ser la misma que declaramos cuando hicimos 'docker build'.
IMAGE=${IMAGE:-"rapid-rodent:latest"}


# Comentar esta linea si se usan volumenes persistentes.
docker run -d --name ${NAME} -v /home/zoo/minecraft/worlds/CoastalTowns:/opt/minecraft/CoastalTowns -p 25565:25565 ${IMAGE}

# NOTA: 
# Si queremos usar un volumen persistente, podemos usar la opcion -v, donde declaramos: 
# /path/al/directorio/local: reemplazar por el directorio local donde queremos guardar nuestros datos
# /opt/minecraft/destino: reemplazar destino por el nombre del directorio donde se va a guardar los datos del mundo de minecraft.
#
# Descomentar la linea de abajo (Sacar el #), si vamos a utilizar volumenes persistentes. Leer la nota de arriba.
# docker run -d --name ${NAME} -v /path/al/directorio/local:/opt/minecraft/destino -p 25565:25565 ${IMAGE}

