#!/bin/bash

### start.sh ###
# by Dalton J. Hanaway, and C. Rose Kennedy

# start.sh - accepts two .xyz for TS and Intermediate. 
#          - calls script to make submission from xyz (int or ts)
#          - runs calls submitter script for both
# 		   - the ts and int xyz files must be in the same directory as this start.sh file

# Syntax:  sh ./start.sh tsGeomFile.xyz intGeomFile.xyz charge multi functional basisSet [reorder atoms (0/1/2)] jobName numberOfProcessors partitionName


echo " "
echo "Beginning processes for Aveda" 
echo " "

echo "## Starting AVEDA for ${8} ## " >> Report_${8}.txt
echo " " >> Report_${8}.txt

cp -r ./Program/ ./${8}
echo "Created job specific directory"

# makes directory to hold input specifications
mkdir ./${8}/inputParameters/

echo ${3} >> ./${8}/inputParameters/charge.txt
echo ${4} >> ./${8}/inputParameters/multi.txt
echo ${5} >> ./${8}/inputParameters/func.txt
echo ${6} >> ./${8}/inputParameters/basis.txt

echo ${7} >> ./${8}/inputParameters/reorder.txt
echo ${8} >> ./${8}/inputParameters/name.txt

echo ${9} >> ./${8}/inputParameters/numProcess.txt

echo ${9} >> ./${8}/inputParameters/memTotalGauss.txt

echo ${10} >> ./${8}/inputParameters/partition.txt

sinfo -p ${10} -h -o=%l | cut -c2- >> ./${8}/inputParameters/maximumTime.txt
 	
echo " Optimizing intermediate and transition state" >> Report_${8}.txt

# Move into program directory and begin optimizations
cp ./${1} ./${8}/1_optimization/"ts.xyz"
cp ./${2} ./${8}/1_optimization/"int.xyz"

mkdir ./${8}/inputGeomFiles/
mv ./${1} ./${8}/inputGeomFiles/
mv ./${2} ./${8}/inputGeomFiles/

cd ./${8}/1_optimization/

sh ./submissionScripter.sh "ts" 0 ${3} ${4} ${5} ${6} ${9} 
sh ./submissionScripter.sh "int" 1 ${3} ${4} ${5} ${6} ${9}


for i in *.gjf; do
 
 	./submitGaussian.sh ${i%%.gjf}
	
done


echo " "
echo "Inital submissions complete,"
echo "Aveda's progress will be logged in Report_${8}.txt"


