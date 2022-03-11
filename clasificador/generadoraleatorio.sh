#!/bin/bash
#Autor: Luis de Jesus
#Generador de archivos aleatoriamente con extensiones de lenguajes de programacion

#Inician las variables

nombrearchivo="extensiones.txt"

stringaleatorio=$(openssl rand -hex 5)

startcontador=0
numarchivos=30

for ((i=0; i<=$numarchivos; i++))
do
echo "numarchivos$i"
done

while IFS= read line
do
#	touch "$stringaleatorio.$line" 
	echo "Se creo $stringaleatorio.$line"
	
done < $nombrearchivo
