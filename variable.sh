#!/bin/bash
#Autor:Luis de Jesus
#Las variables de entorno pueden ser accedidas en cualquier parte del sistema
#Las variables de usuario solo pueden ser accedidas en el script

variable="Hola "
separador="______________________________________________________________________________"

echo $HOME#Esto es un ejemplo de variable de ENTORNO
echo $variable#Esto es un ejemplo de variable de USUARIO
echo $separador
echo "Realizando operaciones Operaciones aritmeticas"
numA=6
numB=8

echo "La + de $numA y $numB es: "$(($numA + $numB))
echo "La - de $numA y $numB es: "$(($numA - $numB))
echo "La * de $numA y $numB es: "$(($numA * $numB))
echo "La / de $numB y $numA es: "$(($numB / $numA))

echo $separador
echo "Realizando operaciones Operaciones Relacionales"
numA=6
numB=8

echo "$numA y $numB es >: "$(($numA > $numB))
echo "$numA y $numB es <: "$(($numA < $numB))
echo "$numA y $numB es >=: "$(($numA >= $numB))
echo "$numA y $numB es <=: "$(($numA <= $numB))
echo "$numA y $numB es ==: "$(($numA == $numB))
echo "$numA y $numB es !=: "$(($numA != $numB))

echo $separador
echo "Realizando operaciones de Asignacion"
numA=6
numB=8



echo "$numA y $numB es +=: "$((numA += numB))
echo "$numA y $numB es -=: "$((numA -= numB))
echo "$numA y $numB es *=: "$((numA *= numB))
echo "$numA y $numB es /=: "$((numA /= numB))
