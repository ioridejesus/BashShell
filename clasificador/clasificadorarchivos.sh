#!/bin/bash
#Autor: Luis de Jesus

#DECLARACION DE VARIABLES

export nombrecarpeta=ArchivosDesordenados

nombreextensiones="extensiones.txt"

separador="________________________________________________________________________________"_

#EJECUATAMOS EL BASH DE GENERAR ALRCHIVOS ALEATORIOS

pwd
while IFS= read line
do
if [ -d "$nombrecarpeta/$line" ]  
then 
mv $nombrecarpeta/*.$line $nombrecarpeta/$line 
echo "$nombrecarpeta/*.$line" "$nombrecarpeta/$line" 
echo "Archivos $line movidos exitosamente"
echo $separador
else
mkdir "${nombrecarpeta}/$line"
chmod -R 777 $nombrecarpeta/$line
echo "Se creo correctamente la carpeta $line"
mv $nombrecarpeta/*.$line $nombrecarpeta/$line 
echo "Archivos $line movidos exitosamente"
echo $separador
fi
done < $nombreextensiones
