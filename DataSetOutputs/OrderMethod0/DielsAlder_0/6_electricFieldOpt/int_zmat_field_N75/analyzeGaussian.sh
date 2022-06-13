#!/bin/bash

curMag=`cat ./lvl.txt`
nextMag="$(($curMag+25))"
nextName="${1%??}${nextMag}"

SUCCESS=-1
STEPS=-1
ANGLEERR=-1


grep -q "Normal termination" "${1}.out"
let SUCCESS=SUCCESS*$?

grep -q "Stationary point" "${1}.out"
let SUCCESS=SUCCESS*$?

grep -q "Number of steps exceeded" "${1}.out" 
let ANGLEERR=ANGLEERR*$?

grep -q "Conversion from Z-matrix to cartesian coordinates failed" "${1}.out" 
let STEPS=STEPS*$?

if [ $SUCCESS -eq 0 ]
then

	cp ${1}.out ../../7_results/${1}.out
	cd ../../7_results/
	sh ./7_Results_boss.sh

	cd ..
	cd 6_electricFieldOpt/${1}/

	echo "success"
	if [ ${nextMag} -ne "125" ]
	then 
		cp ./checkpoint.chk ../${nextName}
		cd ..
		cd ./${nextName}
		sbatch < ./submit_${nextName}.sh
	else
		echo "done with one species"
	fi	
 
elif [ $STEPS -eq 0 ]
then
	cp ../extra.txt .
	cp ../stepErrorSubmissionScripter.sh .
	cp ../newzmatRunnerStepError.sh .
	cp ../stepRestarter.sh .
	rm "${1}.gjf"

	typeStruct=`cat ./struct.txt`

	sbatch < ./newzmatRunnerStepError.sh 

elif [ $ANGLEERR -eq 0 ]
then
	cp ../extra.txt .
	cp ../stepErrorSubmissionScripter.sh .
	cp ../newzmatRunnerStepError.sh .
	cp ../stepRestarter.sh .
	rm "${1}.gjf"

	typeStruct=`cat ./struct.txt`

	sbatch < ./newzmatRunnerStepError.sh 

else
	echo "some unknown error"

fi


