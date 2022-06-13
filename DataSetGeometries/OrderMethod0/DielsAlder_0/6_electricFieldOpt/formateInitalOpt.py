#!/usr/bin/env python

import sys

#formates .xyz for sp
def makeXYZ(name):
	
	file1 = open(name, 'r')
	Lines = file1.readlines()
	Lines.reverse()
	file1.close()

	xyzLines = []
	atomCount = 0

	for line in Lines:
		if "--" in line:
			break
		else:
			atomCount += 1
			xyz = line.strip().split()
			xyz.pop(0)
			xyz.pop(1)
			strLine = ""
			for items in xyz:
				theItem = items + " "
				strLine += theItem
			strLine += "\n"
			xyzLines.append(strLine)

	newFileName = "./" + name.split(".")[0] + "_initalOptXYZ.xyz"
	exportFile = open(newFileName,"w")
	exportFile.write(str(atomCount) + "\n")
	exportFile.write(" \n")
	exportFile.writelines(xyzLines)
	exportFile.close()


makeXYZ(sys.argv[1])



