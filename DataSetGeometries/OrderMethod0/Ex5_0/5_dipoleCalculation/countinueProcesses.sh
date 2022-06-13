#!/bin/bash

numSpDone=$(ls *.out | wc -l)
jName=`cat ../inputParameters/name.txt`

echo "    - Dipole difference aligned in cartesian coordinates" >> ../../Report_${jName}.txt
echo "    - Difference vector mapped to Z-matrix coordinate system" >> ../../Report_${jName}.txt

# copies the results to the applied field directory
cp ./ts_N25.txt ../6_electricFieldOpt/
cp ./int_N25.txt ../6_electricFieldOpt/

cp ./ts_N50.txt ../6_electricFieldOpt/
cp ./int_N50.txt ../6_electricFieldOpt/

cp ./ts_N75.txt ../6_electricFieldOpt/
cp ./int_N75.txt ../6_electricFieldOpt/

cp ./ts_N100.txt ../6_electricFieldOpt/
cp ./int_N100.txt ../6_electricFieldOpt/

echo "    ******************************************" >> ../../Report_${jName}.txt
echo " " >> ../../Report_${jName}.txt
echo " Electric Field Optimizations" >> ../../Report_${jName}.txt

cp dipoleSummary.txt ../7_results/dipoleSummary.txt

# calls the applied E field sequence
cd ../6_electricFieldOpt/
sh ./6_electricFieldOpt_boss.sh 


