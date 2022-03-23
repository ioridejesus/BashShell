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
	export NUMENCABEZADOSESLAVE=$(head -n1 $2 | awk -F',' '{print NF}') 

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
#			echo "=>txt<===============>${ARREGLO[$menosmenos]}" 
#			echo "=>csv<===============>$compositor" 

			if [[ "$compositor" == "${ARREGLO[$menosmenos]}" ]]
			then
				echo "\"$1\"->\"${ARREGLO[$menosmenos]}\" VS \"$2\"->\"$compositor\" Adelante">>$SUCCES
				echo "$separador">>$SUCCES

			else
				
				echo "No se puede continuar debido a: En la linea \"$ok\" los encabezados no coinciden">>$ERRORES
			      	echo "\"${ARREGLO[$menosmenos]} VS \"$compositor\"">>$ERRORES
				echo "$separador">>$ERRORES
				exit 1
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
			exit 1
		fi
	else
		if [[ $2 =~ ^[0-9] ]]
		then
			if [[ $1 =~ ^[0-9]{$2,$2}$ ]]
			then
				echo "$1 es un numero">>$SUCCES
				echo "$separador">>$SUCCES

			else
				NUMCARACTERES=$(echo $1 | awk '{print length($0)}')
				echo "\"$1\" NO es un numero o">>$ERRORES
		       		echo "\"$1\" Debe de contener \"$2\" caracteres y tienes $NUMCARACTERES caracteres">>$ERRORES
				echo "$separador">>$ERRORES
				exit 1
			fi
		else
			echo "$2 NO es un parametro valido">>$ERRORES
			echo "$separador">>$ERRORES
			exit 1
		fi
	fi
}

function ValidarCadena {
	
	if [[ $1 =~ ^[a-zA-ZñÑáéíóúÁÉÍÓÚi] ]]
	then
		echo "$1 es una cadena valida">>$SUCCES
		echo "$separador">>$SUCCES
	else

		echo "$1 cadena no valida solo letras minusculas o mayusculas alfabeto con acento">>$ERRORES
		echo "$separador">>$ERRORES
		exit 1
	fi

}

function ValidarFecha {
	
	if [[ $1 =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]
	then
		echo "Fecha $1 Aceptada">>$SUCCES
		echo "$separador">>$SUCCES
	else

		echo "El formato para la fecha es: YYYY-MM-DD">>$ERRORES
		echo "$separador">>$ERRORES
		exit 1
	fi
}

function ValidarColumnasArchivo {

	NOMBREARCHIVO=$1

	for (( j=1; j<=$NUMENCABEZADOSESLAVE; j++ ))
	do
		export NUMEROCOLUMNA=$j
		echo "El numero de columna a analizar es: $NUMEROCOLUMNA"

		OBTENERCOLUMNA=( $(cat $NOMBREARCHIVO | awk 'BEGIN {FS=","};NR>1{print $apuntadorcolumna}' apuntadorcolumna="$NUMEROCOLUMNA") )

		for i in "${OBTENERCOLUMNA[@]}"
		do
			if [[ $NUMEROCOLUMNA == 1 || $NUMEROCOLUMNA == 2 || $NUMEROCOLUMNA == 3 || $NUMEROCOLUMNA == 5 || $NUMEROCOLUMNA == 6 || $NUMEROCOLUMNA == 9 || $NUMEROCOLUMNA == 10 ]]
			then
				ValidarCadena $i

			elif [[ $NUMEROCOLUMNA == 4 ]]
			then
				ValidarFecha $i

			elif [[ $NUMEROCOLUMNA == 7 ]]
			then
				ValidarNumero $i 

			elif [[ $NUMEROCOLUMNA == 8 ]]
			then
				ValidarNumero $i 10

			elif [[ $NUMEROCOLUMNA == 11 || $NUMEROCOLUMNA == 12 || $NUMEROCOLUMNA == 13 ]]
			then
				ValidarAlfanumerico $i
			else
				echo "No existe la columna: \"$NUMEROCOLUMNA\"">>$ERRORES
				echo "$separador">>$ERRORES
			fi
		done	
	done
}

#Mandamos llamar nuestras funciones

echo "Inicia la bitacora: $FECHA_ACTUAL">>$SUCCES
echo "Inicia la bitacora: $FECHA_ACTUAL">>$ERRORES

ValidarParametros "$NOMBREARCHIVO" "1" "nombre y ruta del archivo CSV" 
ValidarParametros "$ENCABEZADOSARCHIVO" "2" "encabezados del archivo" 

ValidarEncabezados "$ENCABEZADOSARCHIVO" "$NOMBREARCHIVO"

#ValidarNumero 1239875834 10

#ValidarCadena "áéíóú hola mundo" 

ValidarColumnasArchivo $NOMBREARCHIVO

echo "Fin Bitacora">>$SUCCES 
echo "Fin Bitacora">>$ERRORES
echo "">>$SUCCES 
echo "">>$ERRORES
echo "">>$SUCCES 
echo "">>$ERRORES

