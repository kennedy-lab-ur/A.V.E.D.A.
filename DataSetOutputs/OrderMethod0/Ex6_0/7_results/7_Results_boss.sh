#!/bin/bash

### 7_Results_boss.sh ###
# By Dalton J. Hanaway and C. Rose Kennedy

# Pulls out final energy of all 10 geometries for results organization

jName=`cat ../inputParameters/name.txt`

numSpDone=$(ls *.out | wc -l)

if  [ ${numSpDone} == 10 ]  ;
then
	echo "    - All optimizations done" >> ../../Report_${jName}.txt
	echo "    ******************************************" >> ../../Report_${jName}.txt
	echo " " >> ../../Report_${jName}.txt
	
	for sp in *.out ; do
		grep -i -h "SCF Done:" ${sp} | tail -n 1 | grep -o -P '(?<= =).*(?=A.U.)' | tr -d ' ' >> ${sp::-4}_scf.txt
	done
	

	TnF=$(cat ./noField_ts_initalOpt_zmat_sp_scf.txt)
	T25=$(cat ./ts_zmat_field_N25_scf.txt)
	T50=$(cat ./ts_zmat_field_N50_scf.txt)
	T75=$(cat ./ts_zmat_field_N75_scf.txt)
	T100=$(cat ./ts_zmat_field_N100_scf.txt)

	InF=$(cat ./noField_int_initalOpt_zmat_sp_scf.txt)
	I25=$(cat ./int_zmat_field_N25_scf.txt)
	I50=$(cat ./int_zmat_field_N50_scf.txt)
	I75=$(cat ./int_zmat_field_N75_scf.txt)
	I100=$(cat ./int_zmat_field_N100_scf.txt)

	# calls python script to generate graph and .csv
	module load python
	python resultsFormater.py ${TnF} ${T25} ${T50} ${T75} ${T100} ${InF} ${I25} ${I50} ${I75} ${I100}

	echo " Results summarized in ./${jName}/7_Results/" >> ../../Report_${jName}.txt
	echo " " >> ../../Report_${jName}.txt
	echo "## AVEDA Run Complete ## " >> ../../Report_${jName}.txt
	
else 
	echo "    - ${numSpDone}/10 optimization in EEF" >> ../../Report_${jName}.txt
fi


