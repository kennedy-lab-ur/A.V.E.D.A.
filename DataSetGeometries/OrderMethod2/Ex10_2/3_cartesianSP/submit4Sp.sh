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

jName=`cat ../inputParameters/name.txt`
mTime=`cat ../inputParameters/maximumTime.txt`
proc=`cat ../inputParameters/numProcess.txt`
thePart=`cat ../inputParameters/partition.txt`

if [ -f ${1}.gjf ];
then
	usr1=$(whoami)

	# create a directory for files related to the job being submitted
	mkdir "${1}"
	cp ${1}.gjf ./${1}/

    sed s/jobname/${1}/g template4Sp.sh | sed s/processors/${proc}/ | sed s/thePartition/${thePart}/g | sed s/usr/${usr1}/g | sed s/maximum_runtime/${mTime}/g > ./${1}/submit_${1}.sh

	# submit the job using the temporary SLURM submission script
	cd ./${1}/
	sbatch < ./submit_${1}.sh
	cd ..

	# remove the extra input file and the temporary SLURM submission script
	rm ${1}.gjf

else
	echo "File not found for Cartesian SP of ${1} -- job not started." >> ../../Report_${jName}.txt
fi

