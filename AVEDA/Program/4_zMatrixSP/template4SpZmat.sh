#!/bin/bash

#SBATCH -J jobname
#SBATCH -n processors
#SBATCH -N 1
#SBATCH -p thePartition
#SBATCH -t maximum_runtime #Total time limit in hours:minutes:seconds or days-hours
#SBATCH --mem-per-cpu=1500 #Memory per cpu in MB (see also --mem) 
#SBATCH -e run.err
#SBATCH -o run.out

mkdir ./gaussSD
export TMPDIR=./tempDir/
mkdir -p ./tempDir
export GAUSS_SCRDIR=./gaussSD/

#load Gaussian
module load gaussian/16-a03

# run Gaussian
ulimit -c 0
g16 jobname.gjf jobname.out

# clean up scratch
rm -rf ./gaussSD
rm -rf ./tempDir

# copies the output to dipole folder and results folder
cp jobname.out ../../5_dipoleCalculation/zmat_jobname.out
cp jobname.out ../../7_results/noField_jobname.out

rm ./run.out
rm ./run.err

cd ../../5_dipoleCalculation/
sh ./5_dipoleCalculation_boss.sh


