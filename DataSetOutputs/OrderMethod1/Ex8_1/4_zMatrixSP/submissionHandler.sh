#!/bin/bash

### submissionHandler.sh ###
# by Dalton J. Hanaway and C. Rose Kennedy

numSpDone=$(ls *.xyz | wc -l)

jName=`cat ../inputParameters/name.txt`

if  [ ${numSpDone} == 6 ]  ;
then

	# creates .gjf for the generated z-matrix and submits them
	sh ./ZMatReorientedSpSubmissionScripter.sh "ts_initalOpt_zmat" 
	sh ./ZMatReorientedSpSubmissionScripter.sh "int_initalOpt_zmat" 
	
	# copies the z-matrix coordinates to the field opt folder
	cp ./ts_initalOpt_zmat.xyz ../6_electricFieldOpt/ts_zmat.xyz
	cp ./int_initalOpt_zmat.xyz ../6_electricFieldOpt/int_zmat.xyz
	
	# submit each z-matrix sp
	for i in *.gjf; do
 
 		sh ./submit4SpZmat.sh ${i%%.gjf}
	
	done

else 
	echo "Error: files missing for z-matrix sp" >> ../../Report_${jName}.txt
fi


