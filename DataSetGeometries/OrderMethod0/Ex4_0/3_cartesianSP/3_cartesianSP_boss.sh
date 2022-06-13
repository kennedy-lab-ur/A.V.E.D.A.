#!/bin/bash

### 3_cartesianSP_boss.sh ###
# by Dalton J. Hanaway and C. Rose Kennedy

jName=`cat ../inputParameters/name.txt`

numSpDone=$(ls *.xyz | wc -l)

if  [ ${numSpDone} == 2 ]  ;
then
	echo "    - Submitting cartesian coordinate SP" >> ../../Report_${jName}.txt

	# creates submission files for single point calculation in cartesian coordinates
	sh ./SpSubmissionScripter.sh ts_initalOptXYZ_aligned
	sh ./SpSubmissionScripter.sh int_initalOptXYZ_aligned

	for i in *.gjf; do
 
 		sh ./submit4Sp.sh ${i%%.gjf}

	done

else 
	echo "Error: Optimization files missing for cartesian sp" >> ../../Report_${jName}.txt
fi


