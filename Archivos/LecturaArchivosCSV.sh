#!/bin/bash
#########################################################################
#Aplicacion:GENERADOR Y CLASIFICADOR DE ARCHIVOS                        #
#Nombre del shell:LecturaArchivosCSV		 			#
#Tipo de proceso (BATCH u ONLINE): BATCH                                #
#Autor: Luis de Jesus Juan                                              #
#########################################################################
#Recepcion de Parametros

#Ruta y Nombre del Archivo a analizar

export NOMBREARCHIVO=$1

#Ruta y Nombre de los encabezados del archivo

export ENCABEZADOSARCHIVO=$2

#########################################################################
#Declaracion de Variables

export ERRORES="log.txt"
export SUCCES="succes.txt"

separador="-______________________________________________________________________________________________________-"

FECHA_ACTUAL=`date +"%d/%m/%Y %H:%M"`


#########################################################################

#Validamos la entrada de parametros y validamos que existan y tengan informacion

function ValidarParametros {

	if [[ "$1" == "" ]]
	then

		echo "Parametro $2 obligatorio \"$3\"">>$ERRORES
		echo "$separador">>$ERRORES
		exit 1
		
	else

		if [[ -f "$1" ]]
		then

			if [[ -s $1 ]]
			then
	
				echo "Existe informacion en el parametro $2: \"$1\"">>$SUCCES
				echo "$separador">>$SUCCES

			else

				echo "El fichero \"$1\" se encuentra vacio">>$ERRORES
				echo "$separador">>$ERRORES
				exit 1
				
			fi
		else

			echo "El fichero \" $1 \" no existe">>$ERRORES
			echo "$separador">>$ERRORES
			exit 1
		fi	

	fi

	if [[ $ENCABEZADOSARCHIVO == "" ]]
	then

		echo "Parametro 2 obligatorio \"Ruta y nombre del achivo que contiene los encabezados\"">>$ERRORES
		echo "$separador">>$ERRORES
		exit 1
	else
		echo "Existe informacion en el parametro 2: \"$ENCABEZADOSARCHIVO \"">>$SUCCES
		echo "$separador">>$SUCCES

	fi
}


#Inicia La lectura del Archivo

#head -n1 | awk -F',' '{print $1}' Personas.csv 















#Mandamos llamar nuestras funciones

echo "Inicia la bitacora: $FECHA_ACTUAL">>$SUCCES
echo "Inicia la bitacora: $FECHA_ACTUAL">>$ERRORES

ValidarParametros $NOMBREARCHIVO 1 "nombre y ruta del archivo CSV" 
ValidarParametros $ENCABEZADOSARCHIVO 2 "encabezados del archivo" 

echo "Fin Bitacora">>$SUCCES 
echo "Fin Bitacora">>$ERRORES
echo "">>$SUCCES 
echo "">>$ERRORES
echo "">>$SUCCES 
echo "">>$ERRORES

