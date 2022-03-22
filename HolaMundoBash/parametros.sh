#!/bin/bash
#Autor:Luis de Jesus
#Ejemplo de variables y parametros dinamicos

#A continuacion creamos una variable y le pasamos un comando
ubicacion=$(pwd)

#Declaracion de Variables dinamica llenadas por el usuario 

SolicitarNombre=$1
SolicitarApellidos=$2

echo "Hola: $1 $2"
#A continuacion veremos la cantidad de parametros que recibe nuestroarchivo

echo "La cantidad de parametros recibidos son: $#"

echo "Los parametros enviados por el usuarios son: $*"




echo $ubicacion
