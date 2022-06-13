#!/bin/bash

### 2_alignment_boss.sh ###
# by Dalton J. Hanaway and C. Rose Kennedy

# This script handles optimized geometries from (1) and prepares them for single point calculations
# Importantly this script handles the users preference to reorder the atoms on criteria optimal for 
# computationally applied E fields by selecting the non-H atom furthest from the non-H atom which 
# moves the most from the Int to TS

jName=`cat ../inputParameters/name.txt`
reOrd=`cat ../inputParameters/reorder.txt`

numXyz=$(ls *.xyz | wc -l)

# If both structure's optimized geometries are in 2_alignment, alignment sequence proceeds
if [ ${numXyz} == 2 ]  ;
then
	# update log
	echo "    - Second optimization done" >> ../../Report_${jName}.txt
	echo "    ******************************************" >> ../../Report_${jName}.txt
	echo " " >> ../../Report_${jName}.txt
	echo " Structure Alignment" >> ../../Report_${jName}.txt

	module load python

	# aligns intermediate to TS using pyMol
	module load pymol
	python alignPyMol.py "ts_initalOptXYZ.xyz" "int_initalOptXYZ.xyz" ${reOrd}
	echo "    - Intermediate aligned to TS" >> ../../Report_${jName}.txt
	echo "    ******************************************" >> ../../Report_${jName}.txt
	echo " " >> ../../Report_${jName}.txt

	# copies results to next sequences for cartesian and zMatrix single point
	cp ./orderedTs.xyz ../3_cartesianSP/ts_initalOptXYZ_aligned.xyz
	cp ./orderedInt.xyz ../3_cartesianSP/int_initalOptXYZ_aligned.xyz
	cp ./orderedTs.xyz ../4_zMatrixSP/ts_initalOptXYZ_aligned.xyz
	cp ./orderedInt.xyz ../4_zMatrixSP/int_initalOptXYZ_aligned.xyz
	echo " Single Point Calculations" >> ../../Report_${jName}.txt

	#begins both single point calculation sequences
	cd ../3_cartesianSP/
	sh ./3_cartesianSP_boss.sh 
	cd ../4_zMatrixSP/
	sh ./4_zMatrixSP_boss.sh 

else 
	echo "    - First optimization done" >> ../../Report_${jName}.txt
fi


