#!/bin/bash

### 4_zMatrixSP_boss.sh ###
# by Dalton J. Hanaway and C. Rose Kennedy

numSpDone=$(ls *.xyz | wc -l)

jName=`cat ../inputParameters/name.txt`
thePart=`cat ../inputParameters/partition.txt`

if  [ ${numSpDone} == 2 ]  ;
then

	echo "    - Submitting z-matrix SP" >> ../../Report_${jName}.txt
	
	tail -n +3 "int_initalOptXYZ_aligned.xyz" >> "int_unadorned.xyz"
	tail -n +3 "ts_initalOptXYZ_aligned.xyz" >> "ts_unadorned.xyz"

	sed s/'thePartition'/${thePart}/g newzmatRunner.sh > ./specNewZmatRunner.sh

	sbatch < ./specNewZmatRunner.sh

else 
	echo "Error: Optimization files missing for z-matrix sp" >> ../../Report_${jName}.txt
fi


