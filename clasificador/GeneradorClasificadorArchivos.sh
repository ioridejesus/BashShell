#!/bin/bash
########################################################################
#
#
########################################################################

#Declaracion de Variables
ARCHIVOEXTENSIONES="extensiones.txt"

export CARPETAARCHIVOSDESORDENADOS=ArchivosDesordenados/

separador="______________________________________________"

#Validando que el archivo donde se encuentran las extensiones se encuentre

#Funcion para generar archivos aleatoriamente

function GenerarArchivosAleatoriamente {
if [ -f "$ARCHIVOEXTENSIONES" ]
then

if [ -d "$CARPETAARCHIVOSDESORDENADOS" ]
then
	while IFS= read line
	do
		for ((i=0; i<30; i++))
		do

		#Declaramos una cadena aleatoria
		STRINGALEATORIO=$(openssl rand -hex 5)
		touch "$CARPETAARCHIVOSDESORDENADOS$STRINGALEATORIO.$line"
		echo "Se creo $CARPETAARCHIVOSDESORDENADOS$STRINGALEATORIO.$line Correctamente"
		separador="______________________________________________"

	done
	done < $ARCHIVOEXTENSIONES
	
else
	echo "No Existe el directorio $CARPETAARCHIVOSDESORDENADOS"
	echo "$separador"
	separador="______________________________________________"
fi
else

	echo "El fichero $ARCHIVOEXTENSIONES no existe"
	echo "$separador"

fi
}

# Funcion para clasificar los archivos de acuerdo a su extension

function ClasificarArchivos {

	while IFS= read line
	do
		if [ -d "$CARPETAARCHIVOSDESORDENADOS$line" ]
		then
			mv $CARPETAARCHIVOSDESORDENADOS*.$line $CARPETAARCHIVOSDESORDENADOS$line
			echo "Archivos $line clasificados exitosamente"
			echo "$separador"
		else
			mkdir "$CARPETAARCHIVOSDESORDENADOS$line"
			mv $CARPETAARCHIVOSDESORDENADOS*.$line $CARPETAARCHIVOSDESORDENADOS$line
			echo "Carpeta $line creada Exitosamente"
			echo "Archivos $line clasificados exitosamente"
			echo "$separador"
		fi

	done< $ARCHIVOEXTENSIONES


}

#Mandamos llamar nuestras funciones

GenerarArchivosAleatoriamente
ClasificarArchivos

