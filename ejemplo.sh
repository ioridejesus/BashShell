#!/bin/bash

############################## Variables ##############################
FECHA_YYYYMMDD=`date +%Y%m%d` #Formato YYYY MM DD
FECHA_YYMMDDD=`date +%y%m%d` #Formato YY MM DD
HORA="$(date +%H)" # otra manera de invocar expresiones Formato YYYY MM DD
SEQ=0 
############################## Variables ##############################

function FormatNum() {
    if [ $1 -lt 10 ] 
     then 
        NUM_ENV="0$1" 
    else 
       NUM_ENV="$1" 
    fi 
}
function main(){

	ARCH_CONF=ArchivoConArchivos.txt
		echo "YM_MO080102_AAMMDD.txt">$ARCH_CONF
		echo "YM_PC080102_AAMMDD.txt">>$ARCH_CONF
		echo "YM_SM080102_AAMMDD.txt">>$ARCH_CONF
		echo "YM_ST080101_AAMMDD.txt">>$ARCH_CONF
		echo "YM_TE080101_AAMMDD.txt">>$ARCH_CONF
		echo "YM_TR080101_AAMMDD.txt">>$ARCH_CONF
	
	while read LINEA
		do
			NOMBRE_REPLACE=${LINEA//AAMMDD/$FECHA_YYMMDDD}
			touch $NOMBRE_REPLACE
		
	done < $ARCH_CONF


   LENVIA=$(ls YM_*_$FECHA_YYMMDDD.txt | rev | cut -d'/' -f 1)
   for FICH_ORIGEN in $LENVIA
     do
      SEQ=`expr $SEQ + 1`
      FormatNum $SEQ

      HORAE=`date +%H:%M:%S`
      CAD=${FICH_ORIGEN:3:2} # substring de la posicion N
      FICH_DESTINO=$(sed -n "/$CAD/s/HHMMSS/$HORA$SEQ/g;/$CAD/s/AAMMDD/$FECHA_YYYYMMDD/p" Data4File.lst)
		mv $FICH_ORIGEN $FICH_DESTINO
     done
}
main