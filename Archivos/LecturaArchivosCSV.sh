#!/bin/bash
########################################################################################
#Aplicacion:LECTURA DE ARCHIVOS Y SALIDA DE ARCHIVOS DE FORMA ASCENDENTE / DESCENDENTE #
#Nombre del shell:LecturaArchivosCSV												   #
#Tipo de proceso (BATCH u ONLINE): BATCH                                	           #
#Autor: Luis de Jesus Juan                                              	           #
########################################################################################

#################### Fecha y hora en la que inicia nuestro Shell ####################
export FECHA_ACTUAL=$(date +"%d/%m/%Y %H:%M:%S")

#################### Recepcion de Parametros ####################

#Ruta y Nombre del Archivo a analizar (CSV)
export NOMBREARCHIVO=$1

#Ruta y Nombre de los encabezados del archivo (TXT) informacion en lista
export ENCABEZADOSARCHIVO=$2

#Numero de Columna para ordenar debe de ser >= 1 y <= Numero de Columnas del archivo CSV
export ORDENARCOLUMNA=$3

#Tipo de ordenamiento 1 Ascendente 2 Desdendente
export TIPOORDENAMIENTO=$4


#################### Declaracion de Variables #################### 

#Nombre del archivo donde se guardaran los logs
export ERRORES="log.txt"
echo "" >$ERRORES
echo "Inicia la bitacora: $FECHA_ACTUAL" >>$ERRORES
echo "" >>$ERRORES

#Linea que separa los Errores que ocurran
separador="-______________________________________________________________________________________________________-"

#################### Inician las funciones #################### 

#Valida si viene o no vacio el parametro en caso de que venga vacio se termina el programa

function ValidarNoVacio {

	ParametroValidar=$1
	ParametroNumero=$2

	if [[ $ParametroValidar == "" ]]; then
		echo "El Parametro ->$ParametroNumero<- no fue recibido" >>$ERRORES
		echo "$separador" >>$ERRORES
		exit 1
	else
		echo "El Parametro ->$ParametroNumero<- recibido"
	fi

}

# Valida que sea un numero, en caso de contar con una longitud la valida y verifica si sale o no del programa

function ValidarNumero {

	#Recepcion de Parametros
	NumeroValidate=$1
	RangoNumero=$2
	ValidarSalida=$3
	Mensaje_Numero=$4

	if [[ $RangoNumero == "" || $RangoNumero == 0 ]]; then

		if [[ $NumeroValidate =~ ^[0-9] ]]; then
			echo "->$NumeroValidate<- es un numero"
		else
			if [[ $ValidarSalida == 1 ]]
			then

				echo "->$NumeroValidate<- NO es un numero $Mensaje_Numero" >>$ERRORES
				echo "$separador" >>$ERRORES
				exit 1
			else
				echo "->$NumeroValidate<- NO es un numero $Mensaje_Numero" >>$ERRORES
				echo "$separador" >>$ERRORES
			fi

		fi
	else
		if [[ $RangoNumero =~ ^[0-9] ]]; then
			if [[ $NumeroValidate =~ ^[0-9]{$RangoNumero,$RangoNumero}$ ]]; then
				echo "$NumeroValidate es un numero"
			else
				if [[ $ValidarSalida == 1 ]]
				then
					NUMCARACTERES=$(echo $NumeroValidate | awk '{print length($0)}')
					echo "->$NumeroValidate<- NO es un numero o" >>$ERRORES
					echo "->$NumeroValidate<- Debe de contener ->$RangoNumero<- caracteres y tienes ->$NUMCARACTERES<- caracteres $Mensaje_Numero" >>$ERRORES
					echo "$separador" >>$ERRORES
					exit 1
				else
					NUMCARACTERES=$(echo $NumeroValidate | awk '{print length($0)}')
					echo "->$NumeroValidate<- NO es un numero o" >>$ERRORES
					echo "->$NumeroValidate<- Debe de contener ->$RangoNumero<- caracteres y tienes ->$NUMCARACTERES<- caracteres $Mensaje_Numero" >>$ERRORES
					echo "$separador" >>$ERRORES
				fi
			fi
		else 
			if [[ $ValidarSalida == 1 ]]
			then
				echo "->$RangoNumero<- NO es un parametro valido $Mensaje_Numero" >>$ERRORES
				echo "$separador" >>$ERRORES
				exit 1
			else
				echo "->$RangoNumero<- NO es un parametro valido $Mensaje_Numero" >>$ERRORES
				echo "$separador" >>$ERRORES
			fi
		fi
	fi
}


#Validamos la entrada de parametros y validamos que existan y tengan informacion

function ValidarParametros {

	#Recepcion de Parametros
	ArchivoAnalizar=$1
	NumeroParametro=$2
	MensajeError=$3

	#Validamos que no venga vacio el parametro
	if [[ "$ArchivoAnalizar" == "" ]]; then
		echo "Parametro ->$NumeroParametro<- obligatorio ->$MensajeError<-" >>$ERRORES
		echo "$separador" >>$ERRORES
		exit 1
	else
		#Validamos que el fichero exista
		if [[ -f "$ArchivoAnalizar" ]]; then
			#Validamos que el fichero no este vacio
			if [[ -s "$ArchivoAnalizar" ]]; then
				echo "Existe informacion en el parametro $NumeroParametro: ->$ArchivoAnalizar<-"
			else
				echo "El fichero ->$ArchivoAnalizar<- se encuentra vacio" >>$ERRORES
				echo "$separador" >>$ERRORES
				
				DormirBash
			fi
		else
			echo "El fichero ->$ArchivoAnalizar<- no existe" >>$ERRORES
			echo "$separador" >>$ERRORES

			DormirBash
		fi
	fi
}

#Valida archivo que el fichero CSV y TXT contengan el mismo numero de encabezados

function ValidarEncabezados {

	#Recepcion de Parametros
	ArchivoTXT=$1
	ArchivoCSV=$2

	#Contamos el numero de lineas que contiene el archivo txt que contiene los encabezados
	NUMENCABEZADOSMASTER=$(wc $ArchivoTXT | awk '{print $1}')
	echo $NUMENCABEZADOSMASTER

	#Contamos los encabezados del archivo CSV
	export NUMENCABEZADOSESLAVE=$(head -n1 $ArchivoCSV | awk -F',' '{print NF}')
	echo $NUMENCABEZADOSESLAVE
	
	#Validamos que el numero de encabezados sean iguales
	if [[ $NUMENCABEZADOSMASTER = $NUMENCABEZADOSESLAVE ]]; then

		echo "El Archivo donde se definen los encabezados ->$ArchivoTXT<- contiene ->$NUMENCABEZADOSMASTER<- encabezados"
		echo "El Archivo a analizar ->$ArchivoCSV<- contiene ->$NUMENCABEZADOSESLAVE<- encabezados"

		#El archivo que contiene los encabezados (txt) debe de estar en forma de lista y los almacenamos en
		# un arreglo para poder compararlo despues con el fichero csv

		ARREGLO=()

		#Leemos el archivo txt y guardamos cada linea en nuestro arreglo

		while FS= read line; do
			ARREGLO+=($line)
		done <$ArchivoTXT

		#A continuacion Leemos los encabezados de nuestro csv y aprovecharemos ese ciclo for para hacer la
		#comparacion con nuestro array para verificar que esten en la posicion indicada

		menosmenos=0

		for ((i = 1; i <= $NUMENCABEZADOSMASTER; i++)); do

			export ok=$i
			menosmenos=$(($i - 1))
			compositor=$(head -1 $ArchivoCSV | awk 'BEGIN {FS=","};{print $apuntador}' apuntador="$ok")

			echo "Las cadenas a comparar son: ->$compositor<- >-${ARREGLO[$menosmenos]}<-"

			if [[ "$compositor" == "${ARREGLO[$menosmenos]}" ]]; then
				echo "->$ArchivoTXT<-->${ARREGLO[$menosmenos]}<- VS ->$ArchivoCSV<-->$compositor<- Adelante"

			else

				echo "No se puede continuar debido a: En la linea ->$ok<- los encabezados no coinciden" >>$ERRORES
				echo "->${ARREGLO[$menosmenos]}<- VS ->$compositor<-" >>$ERRORES
				echo "$separador" >>$ERRORES
				DormirBash
			fi
		done
	else
		echo "No se puede continuar debido a:" >>$ERRORES
		echo "El Archivo donde se definen los encabezados ->$ArchivoTXT<- contiene ->$NUMENCABEZADOSMASTER<- encabezados" >>$ERRORES
		echo "Y" >>$ERRORES
		echo "El Archivo a analizar ->$ArchivoCSV<- contiene ->$NUMENCABEZADOSESLAVE<- encabezados" >>$ERRORES
		echo "$separador" >>$ERRORES

		DormirBash
	fi
}

# Validamos si la cadena contine solo letras y agregamos la excepcion de la ñ
function ValidarCadena {

	#Recepcion de Parametros
	StringValidar=$1

	if [[ $1 =~ ^[A-Za-zñÑ] ]]; then
		echo "$StringValidar es una cadena valida"
	else

		echo "->$StringValidar<- cadena no valida solo letras minusculas o mayusculas alfabeto con acento" >>$ERRORES
		echo "$separador" >>$ERRORES
		DormirBash
	fi

}

#Validamos el formato de la fecha YYYY-MM-DD
function ValidarFecha {

	#Recepcion de Parametros
	FechaValidar=$1

	if [[ $FechaValidar =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
		echo "Fecha $FechaValidar Aceptada"
	else

		echo "El formato para la fecha es: YYYY-MM-DD" >>$ERRORES
		echo "$separador" >>$ERRORES
		DormirBash
	fi
}

#Validamos que la cadena pueda contener letras y numeros
function ValidarAlfanumerico {

	#Recepcion de Parametros
	StringAlfanumerico=$1

	if [[ $StringAlfanumerico =~ ^[a-zA-Z0-9ñÑáéíóúÁÉÍÓÚitrnvf] ]]; then
		echo "$StringAlfanumerico es una cadena alfanumerica valida"
	else

		echo "->$StringAlfanumerico<- cadena alfanumerica  no valida" >>$ERRORES
		echo "$separador" >>$ERRORES
		DormirBash
	fi

}

# Leemos nuestro archivo CSV y verificamos que cada celda corresponda a un tipo de dato 
function ValidarColumnasArchivo {

	#Recepcion de Parametros
	NOMBREARCHIVO=$1

	for ((j = 1; j <= $NUMENCABEZADOSESLAVE; j++)); do
		export NUMEROCOLUMNA=$j
		echo "El numero de columna a analizar es: $NUMEROCOLUMNA"

		OBTENERCOLUMNA=($(cat $NOMBREARCHIVO | awk 'BEGIN {FS=","};NR>1{print $apuntadorcolumna}' apuntadorcolumna="$NUMEROCOLUMNA"))

		for i in "${OBTENERCOLUMNA[@]}"; do
			if [[ $NUMEROCOLUMNA == 1 || $NUMEROCOLUMNA == 2 || $NUMEROCOLUMNA == 3 || $NUMEROCOLUMNA == 5 || $NUMEROCOLUMNA == 6 || $NUMEROCOLUMNA == 9 || $NUMEROCOLUMNA == 10 ]]; then
				ValidarCadena $i

			elif [[ $NUMEROCOLUMNA == 4 ]]; then
				ValidarFecha $i

			elif [[ $NUMEROCOLUMNA == 7 ]]; then

				ValidarNumero $i "" 2 "en la la columna $j"

			elif [[ $NUMEROCOLUMNA == 8 ]]; then
				ValidarNumero $i 10 2 "en la columna $j"

			elif [[ $NUMEROCOLUMNA == 11 || $NUMEROCOLUMNA == 12 || $NUMEROCOLUMNA == 13 ]]; then
				ValidarAlfanumerico $i
			else
				echo "No existe la columna: ->$NUMEROCOLUMNA<-" >>$ERRORES
				echo "$separador" >>$ERRORES
			fi
		done
	done
}

# ordenamos en un nuevo fichero de forma ascendente o descendete de acuerdo a los parametros establecidos
function Ordenamiento {

	#Recepcion de parametros Columna a ordenar, tipo de ordenamiento (Ascendente, Descendente)
	ORDENARCOLUMNA=$1
	TIPOORDENAMIENTO=$2

	#Validamos que el parametro no venga vacio
	ValidarNoVacio "$ORDENARCOLUMNA" "3"

	#Validamos que la columna que nos indican sea un numero
	ValidarNumero $ORDENARCOLUMNA "" 1 "En el parametro 3"

	#Si la columna que vamos a ordenar es un numero entonces validamos el rango de las columnas
	if (($ORDENARCOLUMNA >= 1 && $ORDENARCOLUMNA <= $NUMENCABEZADOSESLAVE)); then

		#Validamos que el parametro no venga vacio
		ValidarNoVacio "$TIPOORDENAMIENTO" "4"

		#Validamos que el parametro de ordenamiento se un numero
		ValidarNumero $TIPOORDENAMIENTO "" 1 "En el parametro 4"

		#Contamos las lineas que vamos a ordenar excluyendo el encabezado
		TOTALFILAS=$(wc -l $NOMBREARCHIVO | awk '{print $1}')

		#Le Asignamos un nuevo nombre a nuestro archivo con un nombre,nombre columna y fecha
		NombreColumna=$(head -1 $NOMBREARCHIVO | awk 'BEGIN {FS=","};{print $newcolumna}' newcolumna="$ORDENARCOLUMNA")
		Fecha_Archivo=$(date +"%d-%m-%Y-%H-%M-%S")

		if (($ORDENARCOLUMNA == 7 || $ORDENARCOLUMNA == 8)); then

			if (($TIPOORDENAMIENTO == 1)); then

				export VALORESORDENADOS="Ascendente_$NombreColumna$Fecha_Archivo.csv"

				#Primero enviamos al archivo los encabezados
				Encabezado=$(head -1 $NOMBREARCHIVO >>$VALORESORDENADOS)
				#Leemos a partir de la segunda linea, ordenamos y enviamos el resultado al archivo
				Salida=$(tail -$TOTALFILAS $NOMBREARCHIVO | sort -k $ORDENARCOLUMNA -n -t , >>$VALORESORDENADOS)

			elif [[ $TIPOORDENAMIENTO == 2 ]]; then

				export VALORESORDENADOS="Descendente_$NombreColumna$Fecha_Archivo.csv"

				#Primero enviamos al archivo los encabezados
				Encabezado=$(head -1 $NOMBREARCHIVO >>$VALORESORDENADOS)
				#Leemos a partir de la segunda linea, ordenamos y enviamos el resultado al archivo
				Salida=$(tail -$TOTALFILAS $NOMBREARCHIVO | sort -r -k $ORDENARCOLUMNA -n -t , >>$VALORESORDENADOS)

			else

				echo "No existe la codicion ->$TIPOORDENAMIENTO<-" >>$ERRORES
				echo "Opcion ->1<- Ascendente" >>$ERRORES
				echo "Opcion ->2<- Descendente" >>$ERRORES
				echo "$separador" >>$ERRORES
				exit 1
			fi
		else
			if (($TIPOORDENAMIENTO == 1)); then

				export VALORESORDENADOS="Ascendente_$NombreColumna$Fecha_Archivo.csv"

				#Leemos a partir de la segunda linea, ordenamos y enviamos el resultado al archivo
				Salida=$(tail -$TOTALFILAS $NOMBREARCHIVO | sort -k $ORDENARCOLUMNA -t , >>$VALORESORDENADOS)

			elif [[ $TIPOORDENAMIENTO == 2 ]]; then

				export VALORESORDENADOS="Descendente_$NombreColumna$Fecha_Archivo.csv"

				#Primero enviamos al archivo los encabezados
				Encabezado=$(head -1 $NOMBREARCHIVO >>$VALORESORDENADOS)
				#Leemos a partir de la segunda linea, ordenamos y enviamos el resultado al archivo
				Salida=$(tail -$TOTALFILAS $NOMBREARCHIVO | sort -r -k $ORDENARCOLUMNA -t , >>$VALORESORDENADOS)

			else

				echo "No existe la codicion ->$TIPOORDENAMIENTO<-" >>$ERRORES
				echo "Opcion ->1<- Ascendente" >>$ERRORES
				echo "Opcion ->2<- Descendente" >>$ERRORES
				echo "$separador" >>$ERRORES
				exit 1
			fi
		fi
	else

		echo "No existe la columna ->$ORDENARCOLUMNA<-" >>$ERRORES
		echo "$separador" >>$ERRORES
		exit 1
	fi
}

#Creamos una Funcion princial la cual manda llamar a otras funciones para la ejecucion del programa
function ConcatFunctions {

	#Validamos que el ARCHIVO CSV
	ValidarParametros "$NOMBREARCHIVO" "1" "nombre y ruta del archivo CSV"
	echo "Archivo ->$NOMBREARCHIVO<- validado CORRECTAMENTE" >>$ERRORES

	#Validamos que el ARCHIVO TXT
	ValidarParametros "$ENCABEZADOSARCHIVO" "2" "encabezados del archivo"
	echo "Archivo ->$ENCABEZADOSARCHIVO<-validado CORRECTAMENTE" >>$ERRORES

	ValidarEncabezados "$ENCABEZADOSARCHIVO" "$NOMBREARCHIVO"
	echo "Validar encabezados de: ->$NOMBREARCHIVO<- Y ->$ENCABEZADOSARCHIVO<- CORRECTAMENTE" >>$ERRORES

	ValidarColumnasArchivo $NOMBREARCHIVO
	echo "Validacion de Columnas del archivo ->$NOMBREARCHIVO<- CORRECTAMENTE" >>$ERRORES

	Ordenamiento $ORDENARCOLUMNA $TIPOORDENAMIENTO
	echo "Archivo ->$VALORESORDENADOS<- Generado Exitosamente" >>$ERRORES

}

#Verificando el comando sleep
function DormirBash {

	while [[ $Hora_Start -ne "$Hora_End" ]]; do
		FECHA_WHILE=$(date +"%d/%m/%Y %H:%M:%S")
		echo "Validando Funciones: $FECHA_WHILE" >>$ERRORES

		sleep 10s
		ConcatFunctions

		FECHA_SLEEP=$(date +"%d/%m/%Y %H:%M:%S") >>$ERRORES
		echo "Fin Funciones: $FECHA_SLEEP" >>$ERRORES
		#echo "$separador" >>$ERRORES
	done

	FECHA_FIN=$(date +"%d/%m/%Y %H:%M:%S")
	echo "Fin Bitacora: $FECHA_FIN" >>$ERRORES
	echo "" >>$ERRORES
}

#################### Validacion de Parametros Numericos #################### 

# Parametro Columna Ordenamiento que no venga vacio y que sea un numero
ValidarNoVacio "$3" "3"
ValidarNumero $3 "" 1 "el parametro ->3<- indica la columna en la cual se va a ordenar"

# Parametro Columna Ordenamiento que no venga vacio y que sea un numero
ValidarNoVacio "$4" "4"
ValidarNumero $4 "" 1 "el parametro ->4<- indica el ordenamiento 1 Ascendente | 2 Descendente"

#Validamos que el parametro de la hora no venga vacio y la hora que nos envian sea un numero
ValidarNoVacio "$5" "5"

ValidarNumero $5 "" 1 "el parametro ->5<- indica la hora en que finaliza el proceso"

declare -i Hora_End=$5

declare -i Hora_Start="$(date +%H)"

#################### Ejecucion ####################

#Mandamos llamar nuestras funciones

DormirBash
