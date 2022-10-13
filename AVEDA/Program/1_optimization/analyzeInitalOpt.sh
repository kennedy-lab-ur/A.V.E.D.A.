#!/bin/bash

### analyzeInitalOpt ###
# By Dalton J. Hanaway and C. Rose Kennedy

# Extracts the optimized geometry from .out file (asisted by the python script)

tac ${1} | grep -F -m1 -B 999999 'Standard orientation:' | head -n -5 >> ${1::-4}.txt

python formateInitalOpt.py ${1::-4}.txt

# copies results to alignment directory and calls alignment sequenece
cp ./${1::-4}_initalOptXYZ.xyz ../../2_alignment/
cp ./${1::-4}_initalOptXYZ.xyz ../../7_results/geometries/
cp *.out ../../7_results/

cd ../../2_alignment/
sh ./2_alignment_boss.sh



