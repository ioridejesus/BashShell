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

#Funcion GenerarArchivosAleatoriamente

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



#Mandamos llamar nuestras funciones

GenerarArchivosAleatoriamente
