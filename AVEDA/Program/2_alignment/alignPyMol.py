#!/usr/bin/env python

import sys
import __main__
import sys, time, os
import pymol
import numpy as np
import math

__main__.pymol_argv = [ 'pymol', '-qc'] # Quietly load
pymol.finish_launching()


def removeValueFromList(theList, theValue):
	return [value for value in theList if value != theValue]


# Aligns the Int to the TS geometry and saves the .xyz file
def align(tsName, intName):

	with open(tsName) as f:
		tsLines = f.readlines()
		f.close()

	with open(intName) as f:
		intLines = f.readlines()
		f.close()

	pymol.cmd.load(tsName)
	pymol.cmd.load(intName)

	pIntName = intName.split(".")[0]
	pTsName = tsName.split(".")[0]

	aln = pymol.cmd.align(pIntName, pTsName, object='aln')
	raw_aln = pymol.cmd.get_raw_alignment('aln')

	notOrderedAlignments = []
	
	# loop to get the distance between ordered pairs in the TS and Int alignment
	for idx1, idx2 in raw_aln:

		atomNumber = tuple(idx1 + idx2)[1]
		atomKind = tsLines[atomNumber+1].strip().split()[0]
		distance = pymol.cmd.get_distance(idx1, idx2)
		notOrderedAlignments.append([atomNumber, distance, atomKind])

	orderedAlignments = sorted(notOrderedAlignments, key=lambda x: x[1])
	
	pymol.cmd.delete(pTsName)
	pymol.cmd.enable(pIntName)
	pymol.cmd.save("./int_initalOptXYZ.xyz")
	pymol.cmd.quit()

	return orderedAlignments, notOrderedAlignments

def reOrderXYZ(alignmentInfo, tsName, intName):

	with open(tsName) as f:
		tsLines = f.readlines()
		f.close()

	with open(intName) as f:
		intLines = f.readlines()
		f.close()

	firstThreeIndex = [alignmentInfo[0][0]+2, alignmentInfo[1][0]+2, alignmentInfo[2][0]+2]

	tsFirstThree = []
	intFirstThree = []

	
	for i in firstThreeIndex:
		tsFirstThree.append(tsLines[i])
		intFirstThree.append(intLines[i])

		tsLines[i] = "removed"
		intLines[i] = "removed"

	newTS = removeValueFromList(tsLines, "removed") 	
	newInt = removeValueFromList(intLines, "removed") 	

	newTS[2:2] = tsFirstThree
	newInt[2:2] = intFirstThree


	fileTS = open("orderedTs.xyz","w")
	fileTS.writelines(newTS)
	fileTS.close()


	fileInt = open("orderedInt.xyz","w")
	fileInt.writelines(newInt)
	fileInt.close()



def align2(tsName, intName):
	pymol.cmd.load(tsName)
	pymol.cmd.load(intName)

	pIntName = intName.split(".")[0]
	pTsName = tsName.split(".")[0]

	pymol.cmd.align(pIntName, pTsName)

	aln = pymol.cmd.align(pIntName, pTsName, object='aln')

	raw_aln = pymol.cmd.get_raw_alignment('aln')
	
	pymol.cmd.delete(pTsName)
	pymol.cmd.enable(pIntName)

	pymol.cmd.save("./int_initalOptXYZ.xyz")

	pymol.cmd.quit()



def reOrderXYZbyDist(alignmentInfo, tsName, intName):

	with open(tsName) as f:
		tsLines = f.readlines()
		f.close()

	with open(intName) as f:
		intLines = f.readlines()
		f.close()

	firstThreeIndex = [alignmentInfo[0][0]+2, alignmentInfo[1][0]+2, alignmentInfo[2][0]+2]

	tsFirstThree = []
	intFirstThree = []
	
	for i in firstThreeIndex:
		tsFirstThree.append(tsLines[i])
		intFirstThree.append(intLines[i])

		tsLines[i] = "removed"
		intLines[i] = "removed"

	newTS = removeValueFromList(tsLines, "removed") 	
	newInt = removeValueFromList(intLines, "removed") 	

	newTS[2:2] = tsFirstThree
	newInt[2:2] = intFirstThree


	fileTS = open("orderedTs.xyz","w")
	fileTS.writelines(newTS)
	fileTS.close()


	fileInt = open("orderedInt.xyz","w")
	fileInt.writelines(newInt)
	fileInt.close()



def reOrderCenterXYZ(tsName, intName):
	with open(tsName) as f:
		tsLines = f.readlines()
		f.close()

	with open(intName) as f:
		intLines = f.readlines()
		f.close()

	xSum = 0
	ySum = 0
	zSum = 0
	numberOfPoints = float(tsLines[0])
	# middling TS will take 3 int closest to middle 


	for rowsInTS in tsLines[2:]:
		listRow = rowsInTS.split(" ")
		print(listRow)
		print(listRow[1])
		print(listRow[2])
		print(listRow[3])
		print(" ")
		xSum += float(listRow[1])
		ySum += float(listRow[2])
		zSum += float(listRow[3])

	midpoint = np.array([xSum/numberOfPoints , ySum/numberOfPoints , zSum/numberOfPoints ] )

	distanceArray = []
	atomCounter = 0

	for rowLine in tsLines[2:]:
		SecondRowsInTS = rowLine.split(" ")
		indPoint = np.array([float(SecondRowsInTS[1]) , float(SecondRowsInTS[2]) , float(SecondRowsInTS[3])])
		dist = np.linalg.norm(indPoint - midpoint)
		distanceArray.append([atomCounter, abs(dist)])

		atomCounter += 1
		
		
	print(distanceArray)

	orderedDistances = sorted(distanceArray, key=lambda x: x[1])

	
	print(orderedDistances)
	reOrderXYZbyDist(orderedDistances, tsName, intName)


# function to reorder the .xyz by criteria determined above
def reOrderXYZ(alignmentInfo, notOrdAlign, tsName, intName, wantReorder):

	with open(tsName) as f:
		tsLines = f.readlines()
		f.close()

	with open(intName) as f:
		intLines = f.readlines()
		f.close()

	hasHitNonHydrogen = True
	index = len(alignmentInfo)-1

	while hasHitNonHydrogen:
		if alignmentInfo[index][2] != "1":
			mostMoving = alignmentInfo[index][0]
			hasHitNonHydrogen = False
		else :
			index -= 1
		
	numberAtoms=len(tsLines)-2

	iFE = findMostDistantAtom(tsLines, intLines, mostMoving)
	move = False
	reverse = False
	firstAtomIndex = iFE+1
	if wantReorder == "2":
		if (iFE-3)>=0:
			if (iFE+2)<numberAtoms:
				move = True
				#print("was second if")
				#laterTwo = notOrdAlign[iFE][1]+notOrdAlign[iFE+1][1]
				#formerTwo = notOrdAlign[iFE-2][1]+notOrdAlign[iFE-3][1]
				#print("later")
				#print(laterTwo)
				#print("former")
				#print(formerTwo)
	
				#if formerTwo<laterTwo:
					#print("was third if")
					#firstAtomIndex = iFE-1
			
			else:
				reverse = True
				print("two low")
				#might want to reverse here
	
		#move = False

	if move:
		newTS = tsLines[0:2]
		newInt = intLines[0:2]

		newTS += tsLines[firstAtomIndex:]
		newTS += tsLines[2:firstAtomIndex]
		newInt += intLines[firstAtomIndex:]
		newInt += intLines[2:firstAtomIndex]

	elif reverse:
		newTS = tsLines[0:2]
		newInt = intLines[0:2]
		unadornedTs = tsLines[2:]
		unadornedInt = intLines[2:]
		newTS += unadornedTs[::-1]
		newInt += unadornedInt[::-1]
		
	else :
		newTS = tsLines
		newInt = intLines


	# exports the new order to be used in subsequent single point calculations
	fileTS = open("orderedTs.xyz","w")
	fileTS.writelines(newTS)
	fileTS.close()


	fileInt = open("orderedInt.xyz","w")
	fileInt.writelines(newInt)
	fileInt.close()

# Compares the distance matrix between ts and int geometries to find atom which moved the most durign transformation
def findMostDistantAtom(tsLinesL, intLinesL, mostMovingAtom):

	mostMovingIndex = mostMovingAtom + 1
	atomPositionMostMovingRow = tsLinesL[mostMovingIndex].split(" ")
	locationMostMoving = [float(atomPositionMostMovingRow[1]),float(atomPositionMostMovingRow[2]),float(atomPositionMostMovingRow[3])]

	distanceList = []
	atomNumber = 1

	for rowsInTS in tsLinesL[2:]:

		listRow = rowsInTS.split(" ")

		xInd = float(listRow[1])
		yInd = float(listRow[2])
		zInd = float(listRow[3])
		
		xsq = (xInd-locationMostMoving[0])**2
		ysq = (yInd-locationMostMoving[1])**2
		zsq = (zInd-locationMostMoving[2])**2

		sumLoc = xsq + ysq + zsq

		distanceList.append([listRow[0], atomNumber, math.sqrt(sumLoc)])

		atomNumber += 1

	noHDistanceList = removeValueFromList(distanceList, "1")
	ordDistancesNoH = sorted(noHDistanceList, key=lambda x: x[2], reverse=True)

	return ordDistancesNoH[0][1]

if sys.argv[3] == "1" :

	ordAlign = align2(sys.argv[1], sys.argv[2])

	reOrderCenterXYZ(sys.argv[1], sys.argv[2])

else :

	ordAlign, notOrdAlign = align(sys.argv[1], sys.argv[2])
	reOrderXYZ(ordAlign, notOrdAlign, sys.argv[1], sys.argv[2], sys.argv[3])








