#!/bin/bash

### SpSubmissionScripter.sh ###
# by Dalton J. Hanaway and C. Rose Kennedy

# gets input parameters from folder
chrg=`cat ../inputParameters/charge.txt`
multi=`cat ../inputParameters/multi.txt`
func=`cat ../inputParameters/func.txt`
basis=`cat ../inputParameters/basis.txt`
proc=`cat ../inputParameters/numProcess.txt`
jName=`cat ../inputParameters/name.txt`
memGauss=`cat ../inputParameters/memTotalGauss.txt`

if [ -f ${1}.xyz ]
then
	newFileName=${1}_sp.gjf

	# creates .gjf file from optimized geometry of TS and Intermediate for Sp calc
	echo %nprocshared=${proc} >> ${newFileName}
	echo %chk=checkpoint.chk >> ${newFileName}
	echo %mem=${memGauss}GB >> ${newFileName}
	echo \# sp ${func}\/${basis} NoSymm >> ${newFileName}

	echo " " >> ${newFileName}
	echo ${1}_AlignedSp >> ${newFileName}
	echo " " >> ${newFileName}
	echo ${chrg} ${multi} >> ${newFileName}
	tail -n +3 ${1}.xyz >> ${newFileName}
	echo " " >> ${newFileName}
	
else
	echo "Error: Optimization files missing for cartesian sp" >> ../../Report_${jName}.txt
fi

