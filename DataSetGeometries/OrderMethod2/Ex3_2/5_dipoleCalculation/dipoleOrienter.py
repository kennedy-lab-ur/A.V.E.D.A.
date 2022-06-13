#!/usr/bin/env python

import sys
import __main__
import sys, time, os
import numpy as np
import math
import os
from subprocess import call

# calculates the rotation matrix necessary to rotate the aligned dipole moment 
#   difference to the z-matrix coordinate system

def rotationMatrixFrom(vec1, vec2):

	# normalized dipole vectors
	normVec1 = vec1/np.linalg.norm(vec1)
	normVec2 = vec2/np.linalg.norm(vec2)
	a, b = normVec1.reshape(3), normVec2.reshape(3)

	# cross dot (cross) and sin
	v = np.cross(a, b)
	c = np.dot(a, b)
	s = np.linalg.norm(v)

	# rotation matrix calculation from cartesian to z-matrix
	kmat = np.array([[0, -v[2], v[1]], [v[2], 0, -v[0]], [-v[1], v[0], 0]])
	rotation_matrix = np.eye(3) + kmat + kmat.dot(kmat) * ((1 - c) / (s ** 2))

	return rotation_matrix

# uses the aligned cartesian sp results to find the difference in dipole moment between ts and int
def calculateDipoleDifference(tsLocation, intLocation, tsLocZ, intLocZ):

	#reads int and ts dipole moments
	file1 = open(intLocation, 'r')
	intLine = file1.readlines()[0].strip().split()
	intDipoleCart = [float(intLine[1]), float(intLine[3]), float(intLine[5])]
	file1.close()

	file2 = open(tsLocation, 'r')
	tsLine = file2.readlines()[0].strip().split()
	tsDipoleCart = [float(tsLine[1]), float(tsLine[3]), float(tsLine[5])]
	file2.close()

	file3 = open(intLocZ, 'r')
	intLineZ = file3.readlines()[0].strip().split()
	intDipoleZmat = [float(intLineZ[1]), float(intLineZ[3]), float(intLineZ[5])]
	file3.close()
	
	file4 = open(tsLocZ, 'r')
	tsLineZ = file4.readlines()[0].strip().split()
	tsDipoleZmat = [float(tsLineZ[1]), float(tsLineZ[3]), float(tsLineZ[5])]
	file4.close()

	allTheDipoleVectors = [intDipoleCart, tsDipoleCart, intDipoleZmat, tsDipoleZmat]

	oneOfThemIsNothing = False

	for theIndVects in allTheDipoleVectors:
		sumOfZeros = 0
		for eachCart in theIndVects:
			if eachCart == 0.0:
				sumOfZeros += 1

		if sumOfZeros == 3:
			oneOfThemIsNothing = True
		

	if oneOfThemIsNothing == False :

		# calculates the dipole difference in cartesian and z-matrix system and saves it to a file
		diffDipoleCart = [tsDipoleCart[0]-intDipoleCart[0], tsDipoleCart[1]-intDipoleCart[1], tsDipoleCart[2]-intDipoleCart[2]]
	
		# finds matrix to rotate cartesian dipole to z matrix 
		tsCartToZmat = rotationMatrixFrom(tsDipoleCart, tsDipoleZmat)
		intCartToZmat = rotationMatrixFrom(intDipoleCart, intDipoleZmat)
	
		fieldStrengths = [[str(25),-0.0025],[str(50),-0.0050],[str(75),-0.0075],[str(100),-0.01]]
	
		dipoleSummary = open("dipoleSummary.txt", 'a')

		dipoleSummary.write("Int Dipole Moment (Cartesian Coordinates) \n")
		dipoleSummary.write(str(intDipoleCart) + "\n")
		dipoleSummary.write(  "||int dipole|| = " + str(np.linalg.norm(intDipoleCart))+" \n")
		dipoleSummary.write(" \n")

		dipoleSummary.write("TS Dipole Moment (Cartesian Coordinates): \n")
		dipoleSummary.write(str(tsDipoleCart) + "\n")
		dipoleSummary.write(  "||ts dipole|| = " + str(np.linalg.norm(tsDipoleCart)) + " \n")
		dipoleSummary.write(" \n")

		dipoleSummary.write("TS-Int Dipole Difference (Cartesian Coordinates): \n")
		dipoleSummary.write(str(diffDipoleCart) + "\n")
		dipoleSummary.write(  "||dipole diff|| = " + str(np.linalg.norm(diffDipoleCart)) + " \n")

		dipoleSummary.close()



		# Scales the dipole difference vector magnitude so that the applied electric field can be incrimented by those magnitudes
		for magnitude in fieldStrengths:
	
			tsDipoleDiffereceZmatN = magnitude[1]*tsCartToZmat.dot(diffDipoleCart/np.linalg.norm(diffDipoleCart))
			tsDipoleDiffereceZmatStrN = str(tsDipoleDiffereceZmatN[0]) + " " + str(tsDipoleDiffereceZmatN[1]) + " " + str(tsDipoleDiffereceZmatN[2]) + " "
			intDipoleDifferenceZmatN = magnitude[1]*intCartToZmat.dot(diffDipoleCart/np.linalg.norm(diffDipoleCart))
			intDipoleDifferenceZmatStrN = str(intDipoleDifferenceZmatN[0]) + " " + str(intDipoleDifferenceZmatN[1]) + " " + str(intDipoleDifferenceZmatN[2]) + " "

			tsZmatN = open("ts_N" + magnitude[0] + ".txt", 'w')
			tsZmatN.write(tsDipoleDiffereceZmatStrN)
			tsZmatN.close()

			intZmatN = open("int_N" + magnitude[0] + ".txt", 'w')
			intZmatN.write(intDipoleDifferenceZmatStrN)
			intZmatN.close()

		rc = call("./countinueProcesses.sh")
	else :
		rc = call("./stopDueToZero.sh")
	

calculateDipoleDifference(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])


