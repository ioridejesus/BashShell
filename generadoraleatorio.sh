#!/bin/bash
#Autor: Luis de Jesus
#Lectura de un archivo txt el cual contiene la extension de lenguajes de programacion el cual nos ayudara a generar archivos aleatoriamente

#Inician las variables

nombrearchivo="extensiones.txt"
holajs="console.log('Saludos Humano');"
js="js"

#Variables para dia aleatorio
diaaleatorio = $(($RANDOM%31))
mesaleatorio = $(($RANDOM%31))
anioaleatorio = $(($RANDOM%2021)) 
while IFS= read line
do
	touch "Archivo.$line" 
	echo "Se creo Archivo.$line"
	
done < $nombrearchivo
