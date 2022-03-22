#!/usr/bin/env python


### alignPyMol.py ###
# by Dalton J. Hanaway and C. Rose Kennedy

import sys
import __main__
import sys, time, os
import pymol
import math

__main__.pymol_argv = [ 'pymol', '-qc'] # Quietly load
pymol.finish_launching()

#same
# Removes an input value from list and returns the list w/o it
def removeValueFromList(theList, theValue):
	return [value for value in theList if value[0] != theValue]


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


#same
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
	if wantReorder == "y":
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


ordAlign, notOrdAlign = align(sys.argv[1], sys.argv[2])
reOrderXYZ(ordAlign, notOrdAlign, sys.argv[1], sys.argv[2], sys.argv[3])




