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

	echo %nprocshared=12 >> ${1}_field_N25.gjf
	echo %chk=checkpoint.chk >> ${1}_field_N25.gjf
	echo %mem=${memGauss}GB >> ${1}_field_N25.gjf
	if [ ${2} == 0 ]
	then
		
		echo \# Opt=\(TS, CalcFC, noeigentest, Z-matrix, MaxStep=10\) Field=read NoSymm ${func}\/${basis} freq=noraman pop=none >> ${1}_field_N25.gjf

		echo " " >> ${1}_field_N25.gjf
		echo ${1}_initalOpt >> ${1}_field_N25.gjf
		echo " " >> ${1}_field_N25.gjf
		echo ${chrg} ${multi} >> ${1}_field_N25.gjf
		cat ${1}.xyz >> ${1}_field_N25.gjf
		echo " " >> ${1}_field_N25.gjf
		cat ./ts_N25.txt >> ${1}_field_N25.gjf
		cat ./extra.txt >> ${1}_field_N25.gjf

	else

		echo \# Opt=\(Z-matrix, MaxStep=10\) ${func}\/${basis} Field=read NoSymm freq=noraman pop=none >> ${1}_field_N25.gjf

		echo " " >> ${1}_field_N25.gjf
		echo ${1}_initalOpt >> ${1}_field_N25.gjf
		echo " " >> ${1}_field_N25.gjf
		echo ${chrg} ${multi} >> ${1}_field_N25.gjf
		cat ${1}.xyz >> ${1}_field_N25.gjf
		echo " " >> ${1}_field_N25.gjf
		cat ./int_N25.txt >> ${1}_field_N25.gjf
		cat ./extra.txt >> ${1}_field_N25.gjf

	fi


else
	echo "Error: Could not find files for E field Optimization: ${1}" >> ../../Report_${jName}.txt
fi

