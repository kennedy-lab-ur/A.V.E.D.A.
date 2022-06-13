#!/bin/bash

chrg=`cat ../../inputParameters/charge.txt`
multi=`cat ../../inputParameters/multi.txt`
func=`cat ../../inputParameters/func.txt`
basis=`cat ../../inputParameters/basis.txt`
jName=`cat ../../inputParameters/name.txt`
memGauss=`cat ../../inputParameters/memTotalGauss.txt`

#1 name of new gjf (probably original and rename other one first
#2 new zmatrix geometry
#3 electric field
#4 ts or int 


if [ -f ${2}.xyz ]
then
	usr1=$(whoami)

	echo %nprocshared=12 >> ${1}.gjf
	echo %chk=checkpoint.chk >> ${1}.gjf
	echo %mem=${memGauss}GB >> ${1}.gjf
	
	if [ ${4} == "ts" ]
	then
		
		echo \# Opt=\(TS, CalcFC, noeigentest, Z-matrix, MaxStep=10\) Field=read NoSymm ${func}\/${basis} >> ${1}.gjf

		echo " " >> ${1}.gjf
		echo ${1}_initalOpt >> ${1}.gjf
		echo " " >> ${1}.gjf
		echo ${chrg} ${multi} >> ${1}.gjf
		cat ${2}.xyz >> ${1}.gjf
		echo " " >> ${1}.gjf
		cat ./${3} >> ${1}.gjf
		cat ./extra.txt >> ${1}.gjf

	else

		echo \# Opt=\(Z-matrix, MaxStep=10\) ${func}\/${basis} Field=read NoSymm >> ${1}.gjf

		echo " " >> ${1}.gjf
		echo ${1}_initalOpt >> ${1}.gjf
		echo " " >> ${1}.gjf
		echo ${chrg} ${multi} >> ${1}.gjf
		cat ${2}.xyz >> ${1}.gjf
		echo " " >> ${1}.gjf
		cat ./${3} >> ${1}.gjf
		cat ./extra.txt >> ${1}.gjf

	fi

	sbatch < ./submit_${1}.sh

else
	echo "Error: Could not find files for E field Optimization: ${1}" >> ../../Report_${jName}.txt
fi

