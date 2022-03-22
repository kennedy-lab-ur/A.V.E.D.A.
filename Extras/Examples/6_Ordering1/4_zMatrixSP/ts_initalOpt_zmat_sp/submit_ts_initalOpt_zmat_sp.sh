#!/bin/bash

#SBATCH -J ts_initalOpt_zmat_sp
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
g16 ts_initalOpt_zmat_sp.gjf ts_initalOpt_zmat_sp.out

# clean up scratch
rm -rf ./gaussSD
rm -rf ./tempDir

# copies the output to dipole folder and results folder
cp ts_initalOpt_zmat_sp.out ../../5_dipoleCalculation/zmat_ts_initalOpt_zmat_sp.out
cp ts_initalOpt_zmat_sp.out ../../7_results/noField_ts_initalOpt_zmat_sp.out

cd ../../5_dipoleCalculation/
sh ./5_dipoleCalculation_boss.sh

rm ./run.out
rm ./run.err

