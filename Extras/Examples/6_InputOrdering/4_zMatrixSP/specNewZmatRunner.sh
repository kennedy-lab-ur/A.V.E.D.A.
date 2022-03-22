#!/bin/bash

#SBATCH -J newZmat
#SBATCH -n 1
#SBATCH -N 1
#SBATCH -p standard
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

newzmat -ixyz -ocart int_unadorned.xyz int_Bonding.gjf
newzmat -icart -ozmat -noround -redoz -conn int_Bonding.gjf int_zmat.gjf

newzmat -ixyz -ocart ts_unadorned.xyz ts_Bonding.gjf
newzmat -icart -ozmat -noround -redoz -conn ts_Bonding.gjf ts_zmat.gjf

tail -n +6 "int_zmat.gjf" >> "int_minusTop.xyz"
tail -n +6 "ts_zmat.gjf" >> "ts_minusTop.xyz"

awk -v RS= '{print > ("ts_zmatrixSplit_" NR ".xyz")}' ts_minusTop.xyz 
awk -v RS= '{print > ("int_zmatrixSplit_" NR ".xyz")}' int_minusTop.xyz 

rm ts_Bonding.gjf
rm ts_zmat.gjf

rm int_Bonding.gjf
rm int_zmat.gjf

rm ts_minusTop.xyz
rm int_minusTop.xyz

cp ts_zmatrixSplit_1.xyz ts_initalOpt_zmat.xyz
cp int_zmatrixSplit_1.xyz int_initalOpt_zmat.xyz

rm ts_zmatrixSplit_2.xyz
rm int_zmatrixSplit_2.xyz 

rm ts_zmatrixSplit_1.xyz
rm int_zmatrixSplit_1.xyz 

sh ./submissionHandler.sh
