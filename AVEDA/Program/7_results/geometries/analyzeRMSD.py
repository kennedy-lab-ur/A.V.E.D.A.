#!/usr/bin/env python

import sys
import __main__
import math
import csv
import pymol			
	
__main__.pymol_argv = [ 'pymol', '-qc'] # Quietly load
pymol.finish_launching()
			

# calculates RMDS between OEF optimized geometry and inital geometry
def calculateRMSD(noFieldName, listOfGeometryNames):

	noFieldPrefix = noFieldName.split(".")[0]

	pymol.cmd.load(noFieldName)

	csvRows = []
	for geometry in listOfGeometryNames:
		pymol.cmd.load(geometry)
		oefGeometryPrefix = geometry.split(".")[0]

		aln = pymol.cmd.align(oefGeometryPrefix, noFieldPrefix, object='aln')
		csvRows.append([oefGeometryPrefix, aln[0]])
		pymol.cmd.delete(oefGeometryPrefix)

	return csvRows

def analyzeGeometriesRMSD():

	tsNoField = 'ts_initalOpt_zmat_sp.xyz'
	intNoField = 'int_initalOpt_zmat_sp.xyz'


	tsFileNames = ['ts_zmat_field_N25.xyz', 'ts_zmat_field_N50.xyz', 'ts_zmat_field_N75.xyz','ts_zmat_field_N100.xyz']
	intFileNames = ['int_zmat_field_N25.xyz', 'int_zmat_field_N50.xyz', 'int_zmat_field_N75.xyz','int_zmat_field_N100.xyz']
	
	intCSV = calculateRMSD(intNoField, intFileNames)
	tsCSV = calculateRMSD(tsNoField, tsFileNames)
	pymol.cmd.quit()
	totalExportCSV = [["OEFOptimization", "RMSD From No Field Geometry"]] + intCSV + tsCSV
	with open('RMSD_Results.csv', 'w') as f:
    	
		write = csv.writer(f)
		for line in totalExportCSV:
			write.writerow(line)


analyzeGeometriesRMSD()



