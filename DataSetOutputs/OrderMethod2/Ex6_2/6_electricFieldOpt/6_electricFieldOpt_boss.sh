#!/bin/bash

jName=`cat ../inputParameters/name.txt`

numSpDone=$(ls *.out | wc -l)

sh ./eOptsubmissionScripter.sh "ts_zmat" 0
sh ./eOptsubmissionScripter.sh "int_zmat" 1

sh ./submit4eOpt.sh "ts_zmat_field_N25" 0
sh ./submit4eOpt.sh "int_zmat_field_N25" 1


for magnitude in 50 75 100
do 
	sh ./checkSubScripter.sh "ts_zmat" 0 $magnitude
	sh ./checkSubScripter.sh "int_zmat" 1 $magnitude

	sh ./makeCheckDirs.sh "ts_zmat_field_N${magnitude}" $magnitude 0
	sh ./makeCheckDirs.sh "int_zmat_field_N${magnitude}" $magnitude 1

done


