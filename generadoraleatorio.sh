#!/bin/bash
#Autor: Luis de Jesus
#Lectura de un archivo txt el cual contiene la extension de lenguajes de programacion el cual nos ayudara a generar archivos aleatoriamente

#Inician las variables

nombrearchivo="extensiones.txt"
holajs="console.log('Saludos Humano');"
js="js"
while IFS= read line
do
	if [ "$line" = `js` ]; then	
		echo "$line Hola mundo"
	fi
	
	#echo "$line"
done < $nombrearchivo
