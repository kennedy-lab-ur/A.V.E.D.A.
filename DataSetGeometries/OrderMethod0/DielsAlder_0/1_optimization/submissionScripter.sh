#!/bin/bash

### submissionScripter ###
# by Dalton J. Hanaway and C. Rose Kennedy

# Creates .gjf files for inital Gaussian optimization

jName=`cat ../inputParameters/name.txt`
memGauss=`cat ../inputParameters/memTotalGauss.txt`

if [ -f ${1}.xyz ]
then
	usr1=$(whoami)

	# create a directory for files related to the job being submitted
	echo %nprocshared=${7} >> ${1}.gjf
	echo %chk=checkpoint.chk >> ${1}.gjf
	echo %mem=${memGauss}GB >> ${1}.gjf
	# handles making TS and Int submission files differently
	if [ ${2} == 0 ]
	then
		echo \# Opt=\(TS, CalcFC, noeigentest\) ${5}\/${6} freq=noraman pop=none >> ${1}.gjf
	else
		echo \# Opt=tight ${5}\/${6} freq=noraman pop=none >> ${1}.gjf
	fi

	# adds geometry from .xyz file
	echo " " >> ${1}.gjf
	echo ${1}_initalOpt >> ${1}.gjf
	echo " " >> ${1}.gjf
	echo ${3} ${4} >> ${1}.gjf
	tail -n +3 ${1}.xyz >> ${1}.gjf
	echo " " >> ${1}.gjf
	
else
	echo "Error: File not found for optimization - job not started." >> Report_${jName}.txt
	echo 
fi

