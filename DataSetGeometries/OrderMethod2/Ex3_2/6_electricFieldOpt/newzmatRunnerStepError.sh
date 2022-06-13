#!/bin/bash

#SBATCH -J newZmat
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -A exciton -p exciton
#SBATCH -t 1:00:00#Total time limit in hours:minutes:seconds or days-hours
#SBATCH --mem-per-cpu=853 #Memory per cpu in MB (see also --mem) 
#SBATCH -e run.err
#SBATCH -o run.out

mkdir ./gaussSD
export GAUSS_SCRDIR=./gaussSD/

#load Gaussian
module load gaussian/16-a03

# run Gaussian
ulimit -c 0

newzmat -ichk -ozmat -noround -redoz -conn checkpoint.chk lastPoint.gjf

tail -n +6 "lastPoint.gjf" >> "lastPoint_minusTop.xyz"

awk -v RS= '{print > ("lastPoint_zmatrixSplit_" NR ".xyz")}' lastPoint_minusTop.xyz 

rm lastPoint.gjf

rm lastPoint_minusTop.xyz

cp lastPoint_zmatrixSplit_1.xyz lastPoint_initalOptXYZ_zmat.xyz

rm lastPoint_zmatrixSplit_2.xyz

rm lastPoint_zmatrixSplit_1.xyz

sh ./stepRestarter.sh 
