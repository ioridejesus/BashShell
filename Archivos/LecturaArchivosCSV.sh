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

			if [[ -s "$1" ]]
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


#Validar que el archivo CSV y el archivo con los encabezados contengan el mismo numero de encabezados

function ValidarEncabezados {

	#Verificamos que el numero de encabezados de nuestro archivo encabezados tenga el mismo numero de encavezados del archivo a analizar
	#Contamos el numero de lineas que contiene el archivo txt que contiene los encabezados
	NUMENCABEZADOSMASTER=$(wc $1 | awk '{print $1 + 1}')

	#Contamos los encabezados del archivo CSV
	NUMENCABEZADOSESLAVE=$(head -n1 $2 | awk -F',' '{print NF}') 

	if [[ $NUMENCABEZADOSMASTER = $NUMENCABEZADOSESLAVE ]]
	then
		#Al confirmar que el archivo csv y el archivo txt contienen el mismo numero de encabezados
		#enviamos mensaje a la bitacora donde efectivamente coinciden el numero de encabezados esto
	      	#no significa que los encabezados coincidan en el nombre

		echo "El Archivo donde se definen los encabezados \"$1\" contiene \"$NUMENCABEZADOSMASTER\" encabezados">>$SUCCES
		echo "El Archivo a analizar \"$2\" contiene \"$NUMENCABEZADOSESLAVE\" encabezados">>$SUCCES
		echo "$separador">>$SUCCES

		#Declaramos un array para almacenar cada linea de los encabezados en un arreglo
		ARREGLO=()
		#Leemos el archivo que contiene el orden de los encabezados

		while FS= read line
		do
			echo "###$line###"
			ARREGLO+=($line)
		done< $1
		
		
		#A continuacion Leemos los encabezados de nuestro csv y aprovecharemos ese ciclo for para hacer la 
		#comparacion con nuestro array para verificar que esten en la posicion indicada
		menosmenos=0
		for ((i=1; i<$NUMENCABEZADOSMASTER; i++))
		do

		       	export ok=$i
			menosmenos=$(($i -1))
			compositor=$(head -1 $2 | awk 'BEGIN {FS=","};{print $apuntador}' apuntador="$ok")
			echo "=>txt<===============>${ARREGLO[$menosmenos]}" 
			echo "=>csv<===============>$compositor" 

			if [[ "$compositor" == "${ARREGLO[$menosmenos]}" ]]
			then
				echo "El encabezado de nuestro achivo csv \"$compositor\" coincide con el encabezado del txt \"${ARREGLO[$menosmenos]}">>$SUCCES
				
		echo "$separador">>$SUCCES

			else
				
				echo "El encabezado de nuestro achivo csv \"$compositor\" es diferente del encabezado del txt \"${ARREGLO[$menosmenos]}">>$ERRORES
				echo "$separador">>$ERRORES

				

			fi


		done
	else
		echo "No se puede continuar debido a:">>$ERRORES
		echo "El Archivo donde se definen los encabezados \"$1\" contiene \"$NUMENCABEZADOSMASTER\" encabezados">>$ERRORES
		echo "Y">>$ERRORES
		echo "El Archivo a analizar \"$2\" contiene \"$NUMENCABEZADOSESLAVE\" encabezados">>$ERRORES
		echo "$separador">>$ERRORES

		exit 1
	fi		
}

function ValidarNombresEncabezados {

	incrementablearchivo=0

#	while IFS= read line 
#	do
		#if [[ 
#	done< $ENCABEZADOSARCHIVO

}

function ValidarNumero {

	if [[ $2 == "" || $2 == 0 ]]
	then
		if [[ $1 =~ ^[0-9] ]]
		then
			echo "$1 es un numero">>$SUCCES
			echo "$separador">>$SUCCES
		else
			echo "$1 NO es un numero">>$ERRORES
			echo "$separador">>$ERRORES
		fi
	else
		if [[ $2 =~ ^[0-9] ]]
		then
			if [[ $1 =~ ^[0-9]{$2} ]]
			then
				echo "$1 es un numero">>$SUCCES
				echo "$separador">>$SUCCES

			else
				echo "\"$1\" NO es un numero o">>$ERRORES
		       		echo "\"$1\" Debe de contener \"$2\" caracteres ">>$ERRORES
				echo "$separador">>$ERRORES
			fi
		else
			echo "$2 NO es un parametro valido">>$ERRORES
			echo "$separador">>$ERRORES
		fi
	fi
}

function ValidarCadena {
	
	if [[ $1 =~ ^[A-Za-ZÁÉÍÓÚáéíóúñÑ] ]]
	then
		echo "Cadena Valida"
	else
		echo "Cadena invalida"
	fi

} 

#Mandamos llamar nuestras funciones

echo "Inicia la bitacora: $FECHA_ACTUAL">>$SUCCES
echo "Inicia la bitacora: $FECHA_ACTUAL">>$ERRORES

ValidarParametros "$NOMBREARCHIVO" "1" "nombre y ruta del archivo CSV" 
ValidarParametros "$ENCABEZADOSARCHIVO" "2" "encabezados del archivo" 

ValidarEncabezados "$ENCABEZADOSARCHIVO" "$NOMBREARCHIVO"

#ValidarNumero 1234567890 12

#ValidarCadena "ÁCENTO eñe ácento eÑE "


echo "Fin Bitacora">>$SUCCES 
echo "Fin Bitacora">>$ERRORES
echo "">>$SUCCES 
echo "">>$ERRORES
echo "">>$SUCCES 
echo "">>$ERRORES

