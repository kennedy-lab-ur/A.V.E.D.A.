#!/bin/bash

#SBATCH -J ts_initalOptXYZ_aligned_sp
#SBATCH -n 12
#SBATCH -N 1
#SBATCH -p standard
#SBATCH -t 5-00:00:00 #Total time limit in hours:minutes:seconds or days-hours
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
g16 ts_initalOptXYZ_aligned_sp.gjf ts_initalOptXYZ_aligned_sp.out

# clean up gaussian scratch directory
rm -rf ./gaussSD
rm -rf ./tempDir

# copy output to the dipole directory
cp ts_initalOptXYZ_aligned_sp.out ../../5_dipoleCalculation/cart_ts_initalOptXYZ_aligned_sp.out
cd ../../5_dipoleCalculation/
sh ./5_dipoleCalculation_boss.sh

rm ./run.out
rm ./run.err


