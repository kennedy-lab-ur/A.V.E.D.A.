#!/bin/bash


jName=`cat ../inputParameters/name.txt`
echo "in the new file"
echo "ERROR: One of the structures had no molecular dipole moment and thus can't be oriented. We suggest altering the structure with substituents to alter the dipole moment." >> ../../Report_${jName}.txt

