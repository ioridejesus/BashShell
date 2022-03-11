#!/bin/bash
#Autor:Luis de Jesus
#Solicitando datos al usuario para posteriomente mostrar lo ingresado en un mensaje

#Inician las variable
nombre=""
edad=0

read -p "Ingresa tu nombre: " nombre
read -p "Ingresa tu edad: " edad

echo "Tu nombre es: $nombre y tienes $edad años"
