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
mkdir ./tempDir

export GAUSS_SCRDIR=./gaussSD/
export TMPDIR=./tempDir/

#load Gaussian
module load gaussian/16-a03

# run Gaussian
ulimit -c 0
g16 jobname.gjf jobname.out

# clean up gaussian scratch directory
rm -rf ./gaussSD
rm -rf ./tempDir

# copy output to the dipole directory
cp jobname.out ../../5_dipoleCalculation/cart_jobname.out
cd ../../5_dipoleCalculation/
sh ./5_dipoleCalculation_boss.sh

rm ./run.out
rm ./run.err


