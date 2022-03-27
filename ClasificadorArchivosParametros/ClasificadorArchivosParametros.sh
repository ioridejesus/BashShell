#!/bin/bash
#########################################################################
#Aplicacion:GENERADOR Y CLASIFICADOR DE ARCHIVOS                        #
#Nombre del shell: GeneradorClasificadorArchivos						#
#Tipo de proceso (BATCH u ONLINE): BATCH                                #
#Autor: Luis de Jesus Juan                                              #
#########################################################################

#RECEPCION DE PARAMETROS

#Ruta y Nombre del archivo donde se encuentran almacenados nuestras extensiones
 
export ARCHIVOEXTENSIONES=$1

# Ruta de la carpeta donde se generan y clasifican nuestros ficheros

export CARPETAARCHIVOSDESORDENADOS=$2"/"

# Numero de veces que queremos crear un archivo
export NUMARCHIVOS=$3

#########################################################################
#Declaracion de Variables

export ERRORES="log.txt"
export SUCCES="succes.txt"

separador="-______________________________________________________________________________________________________-"

FECHA_ACTUAL=`date +"%d/%m/%Y %H:%M"`

#########################################################################
function ValidarParametros {

	if [[ "$ARCHIVOEXTENSIONES" == "" ]]
	then
		echo "Parametro 1 obligatorio \"Ruta y nombre del achivo\"">>$ERRORES
		echo "$separador">>$ERRORES
		exit 1
	else
		echo "Existe informacion en el parametro 1: \"$ARCHIVOEXTENSIONES\"">>$SUCCES
		echo "$separador">>$SUCCES
	fi
	#Como tal no coloco el nombre de la varible ya que se realiza un concatenacion y no pasaria esta validacion
	if [[ "$2" == "" ]]
	then
		echo "Parametro 2 obligatorio \"Ruta donde se crearan los archivos y carpetas\"">>$ERRORES
		echo "$separador">>$ERRORES
		exit 1
	else
		echo "Existe informacion en el parametro 2: \"$2\"">>$SUCCES
		echo "$separador">>$SUCCES
	fi

	if [[ $NUMARCHIVOS == "" ]]
	then
		NUMARCHIVOS=1
		echo "EL parametro 3 viene vacio por lo tanto equivale a 1">>$SUCCES
		echo "$separador">>$SUCCES

	elif [[ $NUMARCHIVOS =~ ^[0-9] ]]
	then
		NUMARCHIVOS=$NUMARCHIVOS 
		echo "Existe informacion en el parametro 3: \"$NUMARCHIVOS\"">>$SUCCES
		echo "$separador">>$SUCCES
	else
		echo "Imposible continuar debido a que el parametro 3: \"$NUMARCHIVOS\" no es un NUMERO">>$ERRORES
		echo "$separador">>$ERRORES
		exit 1
	fi

} 

# FUNCIONES PARA INSERTAR CODIGO EN NUESTROS NUEVOS FICHEROS

function Holaphp {
	
	export ESCRIBIRPHP=$1
	echo "<?php">>$ESCRIBIRPHP
	echo "echo \"Bienvenido Archivo: </b>$3</b>;\"">>$ESCRIBIRPHP
	echo "?>">>$ESCRIBIRPHP
	echo "Sintaxis $2 escrita correctamente en el archivo $3">>$SUCCES
	echo "$separador">>$SUCCES
	return 1 
	

}

function Holac {

    export ESCRIBIRC=$1
    
    echo "#include <stdio.h>" >>$ESCRIBIRC
    echo "" >>$ESCRIBIRC
    echo "int main()" >>$ESCRIBIRC
    echo "{" >>$ESCRIBIRC
    echo "printf( \"Hola $3.\n\" );" >>$ESCRIBIRC

    echo "" >>$ESCRIBIRC
    echo "" >>$ESCRIBIRC
    echo "return 0;" >>$ESCRIBIRC
    echo "}" >>$ESCRIBIRC
    echo "Sintaxis $2 escrita correctamente en el archivo $3" >>$SUCCES
    echo "$separador" >>$SUCCES
    return 1
}

function Holajava {

    export ESCRIBIRJAVA=$1

    echo "public class $4 {">>$ESCRIBIRJAVA
    echo "">>$ESCRIBIRJAVA
    echo "	public static void main(String[] args) {">>$ESCRIBIRJAVA
    echo "		System.out.println(\"Hola $3.\");">>$ESCRIBIRJAVA
    echo "	}">>$ESCRIBIRJAVA
    echo "">>$ESCRIBIRJAVA
    echo "}">>$ESCRIBIRJAVA

    echo "Sintaxis $2 escrita correctamente en el archivo $3" >>$SUCCES
    echo "$separador" >>$SUCCES
    return 1
}

function Holajavascript {

    export ESCRIBIRJAVASCRIPT=$1

    echo "console.log(\"Hola $3.\");" >>$ESCRIBIRJAVASCRIPT

    echo "Sintaxis $2 escrita correctamente en el archivo $3" >>$SUCCES
    echo "$separador" >>$SUCCES
    return 1
}

function Holapython {

    export ESCRIBIRPYTHON=$1

    echo "print(\"Hola $3\");" >>$ESCRIBIRPYTHON

    echo "Sintaxis $2 escrita correctamente en el archivo $3" >>$SUCCES
    echo "$separador" >>$SUCCES
    return 1
}

function Holasql {

    export ESCRIBIRSQL=$1

    echo "CREATE DATABASE $4" >>$ESCRIBIRSQL
    echo "" >>$ESCRIBIRSQL
    echo "USE $4" >>$ESCRIBIRSQL
    echo "" >>$ESCRIBIRSQL
    echo "CREATE TABLE table_$4 (frase TEXT);" >>$ESCRIBIRSQL
    echo "" >>$ESCRIBIRSQL
    echo "INSERT INTO table_$4 VALUES (\"Hola, $3!\");" >>$ESCRIBIRSQL
    echo "INSERT INTO table_$4 VALUES (\"Adios, $3!\");" >>$ESCRIBIRSQL
    echo "SELECT * FROM table_$4;" >>$ESCRIBIRSQL

    echo "Sintaxis $2 escrita correctamente en el archivo $3" >>$SUCCES
    echo "$separador" >>$SUCCES
    return 1
}


# FUNCIONES DE NUESTRAS CONDICIONALES

function Condicionales {


	if [[ "$2" == "php" ]]
	then
		echo "Existe la funcion para: $2">>$SUCCES	
		echo "$separador">>$SUCCES
		$(Holaphp "$1" "$2" "$3")
		return 1

	elif [[ "$2" == "c" ]]
	then
		echo "Existe la funcion para: $2">>$SUCCES	
		echo "$separador">>$SUCCES
		$(Holac "$1" "$2" "$3")
		return 1

	elif [[ "$2" == "java" ]]
	then
		echo "Existe la funcion para: $2">>$SUCCES	
		echo "$separador">>$SUCCES
		$(Holajava "$1" "$2" "$3" "$4")
		return 1

	elif [[ "$2" == "js" ]]
	then
		echo "Existe la funcion para: $2">>$SUCCES	
		echo "$separador">>$SUCCES
		$(Holajavascript "$1" "$2" "$3" "$4")
		return 1

	elif [[ "$2" == "py" ]]
	then
		echo "Existe la funcion para: $2">>$SUCCES	
		echo "$separador">>$SUCCES
		$(Holapython "$1" "$2" "$3" "$4")
		return 1

	elif [[ "$2" == "sql" ]]
	then
		echo "Existe la funcion para: $2">>$SUCCES	
		echo "$separador">>$SUCCES
		$(Holasql "$1" "$2" "$3" "$4")
		return 1

	else
		echo "Falta realizar una funcion para: \"$2\"">>$ERRORES
		echo "$separador">>$ERRORES
		return 1
	fi
}

#Validando que el fichero donde se encuentren las extensiones EXISTA

#Funcion para generar archivos aleatoriamente

function GenerarArchivosAleatoriamente {

#Se declara una variable para identificar si hay error en alguna linea en especifico
incrementablearchivo=0

#Comprobar que el archivo donde se encuentran almacenadas las extenciones exista
if [ -f "$ARCHIVOEXTENSIONES" ]
then
	#Comprobar que el fichero no este vacio
	if [ -s "$ARCHIVOEXTENSIONES" ]
	then
		#Comprobar que exista el directorio donde se crearan los ficheros y directorios para su posterior clasificacion
		if [ -d "$CARPETAARCHIVOSDESORDENADOS" ]
		then
			while IFS= read line
			do
				incrementablearchivo=$((incrementablearchivo+1))
				if [[ "$line" != "" ]]
				then	
					for ((i=0; i<$NUMARCHIVOS; i++))
					do

					#Declaramos una cadena aleatoria
					STRINGALEATORIO=$(openssl rand -hex 5)
					touch "$CARPETAARCHIVOSDESORDENADOS$STRINGALEATORIO.$line"
					echo "Se creo $CARPETAARCHIVOSDESORDENADOS$STRINGALEATORIO.$line Correctamente">>$SUCCES
					echo "$separador">>$SUCCES
					
					#$(Condicionales "$CARPETAARCHIVOSDESORDENADOS$STRINGALEATORIO.$line" "$line" "$STRINGALEATORIO.$line" "$STRINGALEATORIO")

					Condicionales $CARPETAARCHIVOSDESORDENADOS$STRINGALEATORIO.$line $line $STRINGALEATORIO.$line $STRINGALEATORIO

		openssl rand -hex 5openssl rand -hex 5openssl rand -hex 5openssl rand -hex 5		done
				else
					echo "No se puede crear este archivo debido a: La linea $incrementablearchivo se encuentra vacia ">>$ERRORES
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
		
		if [[ "$line" != "" ]]
		then	
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

		fi
	done< $ARCHIVOEXTENSIONES


}


#Mandamos llamar nuestras funciones

echo "Inicia la bitacora: $FECHA_ACTUAL">>$SUCCES
echo "Inicia la bitacora: $FECHA_ACTUAL">>$ERRORES

ValidarParametros $1 $2 $ARCHIVOEXTENSIONES
GenerarArchivosAleatoriamente
ClasificarArchivos

echo "Fin Bitacora">>$SUCCES 
echo "Fin Bitacora">>$ERRORES
echo "">>$SUCCES 
echo "">>$ERRORES
echo "">>$SUCCES 
echo "">>$ERRORES
