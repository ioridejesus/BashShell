#!/bin/bash
#########################################################################
#Aplicacion:GENERADOR Y CLASIFICADOR DE ARCHIVOS                        #
#Nombre del shell: GeneradorClasificadorArchivos			#
#Tipo de proceso (BATCH u ONLINE): BATCH                                #
#Autor: Luis de Jesus Juan                                              #
#########################################################################
#Declaracion de Variables
ARCHIVOEXTENSIONES="extensiones.txt"

export CARPETAARCHIVOSDESORDENADOS=ArchivosDesordenados/

separador="-________________________________________________________-"

#Validando que el archivo donde se encuentran las extensiones se encuentre

#Funcion para generar archivos aleatoriamente

function GenerarArchivosAleatoriamente {
if [ -f "$ARCHIVOEXTENSIONES" ]
then

	if [ -s "$ARCHIVOEXTENSIONES" ]
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
				echo "Se creo $CARPETAARCHIVOSDESORDENADOS$STRINGALEATORIO.$line Correctamente">>succes.txt
				echo "$separador">>succes.txt

				done
			done < $ARCHIVOEXTENSIONES
			
	
		else
		echo "No Existe el directorio $CARPETAARCHIVOSDESORDENADOS">>log.txt
		echo "$separador">>log.txt
		exit 1
		fi
	else
		echo "El fichero $ARCHIVOEXTENSIONES se encuentra vacio">>log.txt
		echo "$separador">>log.txt
		exit 1
	fi
else

	echo "El fichero $ARCHIVOEXTENSIONES no existe">>log.txt
	echo "$separador">>log.txt
	exit 1

fi
}

# Funcion para clasificar los archivos de acuerdo a su extension

function ClasificarArchivos {

	while IFS= read line
	do
		if [ -d "$CARPETAARCHIVOSDESORDENADOS$line" ]
		then
			mv $CARPETAARCHIVOSDESORDENADOS*.$line $CARPETAARCHIVOSDESORDENADOS$line
			echo "Archivos $line clasificados exitosamente">>succes.txt
			echo "$separador">>succes.txt
		else
			mkdir "$CARPETAARCHIVOSDESORDENADOS$line"
			mv $CARPETAARCHIVOSDESORDENADOS*.$line $CARPETAARCHIVOSDESORDENADOS$line
			echo "Carpeta $line creada Exitosamente">>succes.txt
			echo "Archivos $line clasificados exitosamente">>succes.txt
			echo "$separador">>succes.txt
		fi

	done< $ARCHIVOEXTENSIONES


}

#Mandamos llamar nuestras funciones

GenerarArchivosAleatoriamente
ClasificarArchivos

