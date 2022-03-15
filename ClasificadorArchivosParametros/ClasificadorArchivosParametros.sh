#!/bin/bash
#########################################################################
#Aplicacion:GENERADOR Y CLASIFICADOR DE ARCHIVOS                        #
#Nombre del shell: GeneradorClasificadorArchivos			#
#Tipo de proceso (BATCH u ONLINE): BATCH                                #
#Autor: Luis de Jesus Juan                                              #
#########################################################################

#RECEPCION DE PARAMETROS

#Recibir ruta y nombre del archivo Y Ruta donde se encuentran los archivos desordenados 
 
ARCHIVOEXTENSIONES=$1

export CARPETAARCHIVOSDESORDENADOS=$2"/"


#Declaracion de Variables
#ARCHIVOEXTENSIONES="extensiones.txt"
ERRORES="log.txt"
SUCCES="succes.txt"

#export CARPETAARCHIVOSDESORDENADOS=ArchivosDesordenados/

separador="-________________________________________________________-"

function ValidarParametros {

	if [[ "$1" == "" ]]
	then
		echo "Imposible continuar debido a que el parametro 1 es obligatorio">>$ERRORES
		echo "$separador">>$ERRORES
		exit 1
	else
		echo "Existe informacion en el parametro 1: $1">>$SUCCES
		echo "$separador">>$SUCCES
	fi

	if [[ "$2" == "" ]]
	then
		echo "Imposible continuar debido a que el parametro 2 es obligatorio">>$ERRORES
		echo "$separador">>$ERRORES
		exit 1
	else
		echo "Existe informacion en el parametro 2: $2">>$SUCCES
		echo "$separador">>$SUCCES
	fi

} 

#Validando que el fichero donde se encuentren las extensiones EXISTA

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
				if [[ "$line" != "" ]]
				then	
					for ((i=0; i<30; i++))
					do

					#Declaramos una cadena aleatoria
					STRINGALEATORIO=$(openssl rand -hex 5)
					touch "$CARPETAARCHIVOSDESORDENADOS$STRINGALEATORIO.$line"
					echo "Se creo $CARPETAARCHIVOSDESORDENADOS$STRINGALEATORIO.$line Correctamente">>$SUCCES
					echo "$separador">>$SUCCES

				done
				else
					echo "No se puede crear este archivo debido a: La linea se encuentra vacia ">>$ERRORES
					echo "$separador">>$ERRORES
			fi	
			done < $ARCHIVOEXTENSIONES
			
	
		else
		echo "No Existe el directorio $CARPETAARCHIVOSDESORDENADOS">>$ERRORES
		echo "$separador">>$ERRORES
		exit 1
		fi
	else
		echo "El fichero $ARCHIVOEXTENSIONES se encuentra vacio">>$ERRORES
		echo "$separador">>$ERRORES
		exit 1
	fi
else

	echo "El fichero $ARCHIVOEXTENSIONES no existe">>$ERRORES
	echo "$separador">>$ERRORES
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
			echo "Archivos $line clasificados exitosamente">>$SUCCES
			echo "$separador">>$SUCCES
		else
			mkdir "$CARPETAARCHIVOSDESORDENADOS$line"
			mv $CARPETAARCHIVOSDESORDENADOS*.$line $CARPETAARCHIVOSDESORDENADOS$line
			echo "Carpeta $line creada Exitosamente">>$SUCCES
			echo "Archivos $line clasificados exitosamente">>$SUCCES
			echo "$separador">>$SUCCES
		fi

	done< $ARCHIVOEXTENSIONES


}

#Mandamos llamar nuestras funciones

ValidarParametros $1 $2
GenerarArchivosAleatoriamente
#ClasificarArchivos

