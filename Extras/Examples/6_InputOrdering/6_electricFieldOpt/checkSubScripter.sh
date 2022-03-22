#!/bin/bash

chrg=`cat ../inputParameters/charge.txt`
multi=`cat ../inputParameters/multi.txt`
func=`cat ../inputParameters/func.txt`
basis=`cat ../inputParameters/basis.txt`
jName=`cat ../inputParameters/name.txt`
memGauss=`cat ../inputParameters/memTotalGauss.txt`

if [ -f ${1}.xyz ]
then
	usr1=$(whoami)
	# create a directory for files related to the job being submitted
	echo "creating a .gjf for ${1}"

	echo %nprocshared=12 >> ${1}_field_N${3}.gjf
	echo %chk=checkpoint.chk >> ${1}_field_N${3}.gjf
	echo %mem=${memGauss}GB >> ${1}_field_N${3}.gjf

	if [ ${2} == 0 ]
	then

		echo \# Opt=\(TS, CalcFC, noeigentest, Z-matrix, MaxStep=10\) geom=allcheckpoint guess=read Field=read NoSymm ${func}\/${basis} >> ${1}_field_N${3}.gjf

		echo " " >> ${1}_field_N${3}.gjf
		cat ./ts_N${3}.txt >> ${1}_field_N${3}.gjf
		cat ./extra.txt >> ${1}_field_N${3}.gjf

	else

		echo \# Opt=\(Z-matrix, MaxStep=10\) ${func}\/${basis} geom=allcheckpoint guess=read Field=read NoSymm >> ${1}_field_N${3}.gjf

		echo " " >> ${1}_field_N${3}.gjf
		cat ./int_N${3}.txt >> ${1}_field_N${3}.gjf
		cat ./extra.txt >> ${1}_field_N${3}.gjf

	fi


else
	echo "Error: Could not find files for E field Optimization: ${1}" >> ../../Report_${jName}.txt
fi

