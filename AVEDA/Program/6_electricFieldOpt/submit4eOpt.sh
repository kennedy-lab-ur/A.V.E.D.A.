#!/bin/bash

# Gaussian/SLURM Job Submission Script
# C. Rose Kennedy 2014-11-05
# updated (CRK) 2019-10-27, 2021-04-11

# Description:
# - creates a directory for your job
# - moves the job input file from the current directory into this new job directory
# - submits the job to SLURM with the specified options
# - upon completion of the job, moves the output file to the output directory
# - shared memory (RAM) on local node is used

# Syntax:
# You must have this file (UR_submitGaussian.sh) as well as the template file (UR_templateGaussian.sh), and the analysis script (UR_analyzeGaussian.sh) in the same directory.
# Execute the script as follows:

# ./UR_submitGaussian.sh input_filename number_processors maximum_runtime

# Notes:
# input_filename: assumes .gjf extension (e.g., write "test01" instead of "test01.gjf")
# number_processors: the number of processors you want. Request the same number of processors requested in your Gaussian jobcard.
# maximum_runtime (optional): in hours:minutes:seconds or days-hours, the maximum length of time you want your jobs to run. Jobs requesting a shorter runtime will be scheduled more rapidly. If you do not request a maximum runtime, the default is 12 hours.

jName=`cat ../inputParameters/name.txt`
mTime=`cat ../inputParameters/maximumTime.txt`
proc=`cat ../inputParameters/numProcess.txt`
thePart=`cat ../inputParameters/partition.txt`


if [ -f ${1}.gjf ];
then
	usr1=$(whoami)
	# create a directory for files related to the job being submitted
	echo "creating a directory for files related to ${1}"
	mkdir "${1}"
	cp ${1}.gjf ./${1}/
	cp analyzeGaussian.sh ./${1}/
	cp stepErrorSubmissionScripter.sh ./${1}/
	cp formateInitalOpt.py ./${1}/

	if [ ${2} == 1 ];
	then 
		echo "int" >> ./${1}/struct.txt
		mv "int_N25.txt" ./${1}/
	else 
		echo "ts" >> ./${1}/struct.txt
		mv "ts_N25.txt" ./${1}/
	fi 

	# create a temporary SLURM submission script from the template (UR_templateGaussian.sh) and the user-indicated options
	echo "creating a temporary SLURM submission script for ${1}"

    sed s/jobname/${1}/g template4eOpt.sh | sed s/processors/${proc}/ | sed s/thePartition/${thePart}/g | sed s/usr/${usr1}/g | sed s/maximum_runtime/${mTime}/g > ./${1}/submit_${1}.sh

	# submit the job using the temporary SLURM submission script
	cd ./${1}/
	echo "25" >> lvl.txt
	sbatch < ./submit_${1}.sh
	cd ..

	# remove the extra input file and the temporary SLURM submission script
	rm ${1}.gjf

else
	echo "Error: files missing for E-field opt of ${1}" >> ../../Report_${jName}.txt
fi

