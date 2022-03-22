#!/bin/bash

#SBATCH -J int_zmat_field_N50
#SBATCH -n 12
#SBATCH -N 1
#SBATCH -p standard
#SBATCH -t 120:00:00 #Total time limit in hours:minutes:seconds or days-hours
#SBATCH --mem-per-cpu=1500 #Memory per cpu in MB (see also --mem) 
#SBATCH -e run.err
#SBATCH -o run.out

mkdir ./gaussSD
mkdir ./tempDir

export GAUSS_SCRDIR=./gaussSD/
export TMPDIR=./tempDir/

jName=`cat ../../inputParameters/name.txt`

echo "    - Submitting int_zmat_field_N50 for E-Field Opt" >> ../../../Report_${jName}.txt

#load Gaussian
module load gaussian/16-a03

# run Gaussian
ulimit -c 0
g16 int_zmat_field_N50.gjf int_zmat_field_N50.out

# clean up scratch
rm -rf ./gaussSD
rm -rf ./tempDir

cp int_zmat_field_N50.out ../../7_results/int_zmat_field_N50.out
cd ../../7_results/
sh ./7_Results_boss.sh

cd ..
cd 6_electricFieldOpt/int_zmat_field_N50/

sh ./analyzeGaussian.sh int_zmat_field_N50

