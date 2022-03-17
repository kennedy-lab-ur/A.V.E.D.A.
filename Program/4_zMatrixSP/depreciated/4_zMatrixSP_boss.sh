#!/bin/bash

### 4_zMatrixSP_boss.sh ###
# by Dalton J. Hanaway and C. Rose Kennedy

numSpDone=$(ls *.xyz | wc -l)

proc=`cat ../inputParameters/numProcess.txt`
jName=`cat ../inputParameters/name.txt`

if  [ ${numSpDone} == 2 ]  ;
then

	echo "    - Submitting z-matrix SP" >> ../../Report_${jName}.txt

	# uses gc.py open sourced program to convert cartesian coordinates to z-matrix
	module load python
	python gc.py -xyz "ts_initalOptXYZ.xyz"
	python gc.py -xyz "int_initalOptXYZ.xyz"

	# creates .gjf for the generated z-matrix and submits them
	sh ./ZMatReorientedSpSubmissionScripter.sh "ts_initalOptXYZ_zmat" 
	sh ./ZMatReorientedSpSubmissionScripter.sh "int_initalOptXYZ_zmat" 
	
	# copies the z-matrix coordinates to the field opt folder
	cp ./ts_initalOptXYZ_zmat.xyz ../6_electricFieldOpt/
	cp ./int_initalOptXYZ_zmat.xyz ../6_electricFieldOpt/
	
	#sh ./batch4SpZmat.sh ${proc} 24:00:00

	for i in *.gjf; do
 
 		sh ./submit4SpZmat.sh ${i%%.gjf} ${proc}
	
	done

else 
	echo "Error: Optimization files missing for z-matrix sp" >> ../../Report_${jName}.txt
fi


