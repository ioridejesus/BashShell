#!/bin/bash
#Autor: Luis de Jesus
#Generador de archivos aleatoriamente con extensiones de lenguajes de programacion

#DECLARACION DE VARIABLES

nombrearchivo="extensiones.txt"

export rutaarchivosdesordenados=ArchivosDesordenados/

while IFS= read line
do
for ((i=0; i<30; i++))
do
#declaramos nuestra cadena aleatoriamente
stringaleatorio=$(openssl rand -hex 5)
	touch "$rutaarchivosdesordenados$stringaleatorio.$line" 
	echo "Se creo $stringaleatorio.$line"
done	
done < $nombrearchivo
