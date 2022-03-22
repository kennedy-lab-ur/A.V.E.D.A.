#!/bin/bash

curMag=`cat ./lvl.txt`
typeStruct=`cat ./struct.txt`

sh ./stepErrorSubmissionScripter.sh "${typeStruct}_initalOptXYZ_zmat_XN${curMag}" "lastPoint_initalOptXYZ_zmat" "${typeStruct}_N${curMag}.txt" ${typeStruct}
