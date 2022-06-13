#!/bin/bash

numSpDone=$(ls *.out | wc -l)
jName=`cat ../inputParameters/name.txt`

# if all 4 single point calculations are done the dipole information is extracted from the output
if  [ ${numSpDone} == 4 ]  ;
then
	
	echo "    - All 4 single point calculations are done" >> ../../Report_${jName}.txt
	echo "    ******************************************" >> ../../Report_${jName}.txt
	echo " " >> ../../Report_${jName}.txt

	echo " Dipole Analysis" >> ../../Report_${jName}.txt

	for sp in *.out ; do
		echo ${sp}
		grep -i -A1 "Dipole moment (field-independent basis, Debye):" ${sp} | tail -n 1 >> ${sp::-4}_dipole.txt
	
	done
	ls
	# calls the python script to perform vector algebra on the dipole moments
	module load python
	python dipoleOrienter.py "cart_ts_initalOptXYZ_aligned_sp_dipole.txt" "cart_int_initalOptXYZ_aligned_sp_dipole.txt" "zmat_ts_initalOpt_zmat_sp_dipole.txt" "zmat_int_initalOpt_zmat_sp_dipole.txt"


else 
	echo "    - ${numSpDone}/4 single point computations done" >> ../../Report_${jName}.txt
fi


