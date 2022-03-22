#!/bin/bash

### run_ArbAlign.sh ###
# by Dalton J. Hanaway and C. Rose Kennedy

# This script generates an ArbAlign instance to prepare misaligned geometries for A.V.E.D.A.

if [[ -f ./${1} && -f ./${2} ]]  ;
then

	cp -r ./BlankArbAlign ./ArbAlign

	# calls ArbAlign to reorder intermediate to TS by connectivity 
	module load python
	cp ./${1} ./ArbAlign/
	cp ./${2} ./ArbAlign/

	cd ./ArbAlign/
	python ArbAlign-driver.py -b 'c' "${2}" "${1}"

	cp ./molecule-aligned_to-reference.xyz ../int_orderedByTS.xyz
	cd ..

	rm -r ./ArbAlign

else 
	echo "error finding geometry files"
fi


