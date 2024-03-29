#!/bin/bash

#SBATCH -J ts_zmat_field_N100
#SBATCH -n 12
#SBATCH -N 1
#SBATCH -p standard
#SBATCH -t 120:00:00 #Total time limit in hours:minutes:seconds or days-hours
#SBATCH --mem-per-cpu=1500 #Memory per cpu in MB (see also --mem) 
#SBATCH -e run.err
#SBATCH -o run.out

mkdir ./gaussSD
export TMPDIR=./tempDir/
mkdir -p ./tempDir
export GAUSS_SCRDIR=./gaussSD/

jName=`cat ../../inputParameters/name.txt`

echo "    - Submitting ts_zmat_field_N100 for E-Field Opt" >> ../../../Report_${jName}.txt

#load Gaussian
module load gaussian/16-a03

# run Gaussian
ulimit -c 0
g16 ts_zmat_field_N100.gjf ts_zmat_field_N100.out

# clean up scratch
rm -rf ./gaussSD
rm -rf ./tempDir

cp ts_zmat_field_N100.out ../../7_results/ts_zmat_field_N100.out
cd ../../7_results/
sh ./7_Results_boss.sh

cd ..
cd 6_electricFieldOpt/ts_zmat_field_N100/

sh ./analyzeGaussian.sh ts_zmat_field_N100

