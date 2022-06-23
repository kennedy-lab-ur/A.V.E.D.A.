#!/usr/bin/env python

### resultsFormater.py ###
# By Dalton J. Hanaway and C. Rose Kennedy

# Organizes results into csv and graphs the change in transformation barrier

import sys
import __main__
import sys, time, os
import csv
import math
import numpy as np
import matplotlib.pyplot as plt


def exportResults(TnF, T25, T50, T75, T100, InF, I25, I50, I75, I100):
	
	hartree = [float(TnF.strip()), float(T25.strip()), float(T50.strip()), float(T75.strip()), float(T100.strip()), float(InF.strip()), float(I25.strip()), float(I50.strip()), float(I75.strip()), float(I100.strip())]


	kcal = [ hrt * 627.5 for hrt in hartree ]
	
	deltKcal = [ kcal[0] - kcal[5] , kcal[1] - kcal[6] , kcal[2] - kcal[7], kcal[3] - kcal[8], kcal[4] - kcal[9]]

	deltDeltKcal = [ 0, deltKcal[1] - deltKcal[0] , deltKcal[2] - deltKcal[0] , deltKcal[3] - deltKcal[0] , deltKcal[4] - deltKcal[0] ]

	field = [0,-25,-50,-75,-100]
	fig, ax = plt.subplots(figsize=(8,6))
	plt.scatter(field,deltKcal,s=80,color='steelblue',label='optimized barriers', zorder=2)

	z = np.polyfit(field, deltKcal, 1)

	p = np.poly1d(z)

	m = round(p.c[0],3)
	b = round(p.c[1],3)

	correlation_matrix = np.corrcoef(field, deltKcal)
	correlation_xy = correlation_matrix[0,1]
	r_2 = round(correlation_xy**2,5)

	lineLable = "("+str(m)+")" + "x + " + str(b) + "\nR${}^{2}$ = " + str(r_2)
	ax.plot(field,p(field),color='gainsboro',linewidth=2.2,zorder=1,label=lineLable)

	plt.title("OEF Results", fontweight='bold')
	
	plt.xlabel('Field Strength along $\Delta$$\mu$ ($10^{-4}$ a.u.)')
	plt.ylabel('Transformatiom Barrier ($\Delta$ kcal/mol)')

	leg = ax.legend(bbox_to_anchor=(0.97, 0.2297), bbox_transform=ax.transAxes, scatterpoints=1,fontsize="small")
	for line in leg.get_lines():
		line.set_linewidth(4.7)

	plt.xlim([-110,10])

	plt.savefig('./OEF_Results.png', dpi=400, bbox_inches='tight')

	

	header = ["Results" ," " ," ", " "," ", " "]
	line1 = [ "Field [10^{-4} a.u.]" ," 0" , " -25 " , " -50 " ," -75 " ," -100 "] 
	line2 = ["Int [a.u.]" , InF , I25, I50, I75, I100 ]
	line3 = ["TS [a.u.]" , TnF , T25, T50, T75, T100 ]


	line4 = ["Delta E [kcal/mol]" , str(deltKcal[0]) , str(deltKcal[1]), str(deltKcal[2]), str(deltKcal[3]), str(deltKcal[4])]
	line5 = ["Delta Delta E [kcal/mol]" , str(deltDeltKcal[0]) , str(deltDeltKcal[1]), str(deltDeltKcal[2]), str(deltDeltKcal[3]), str(deltDeltKcal[4])]

	
	with open('AppliedFieldResults.csv', 'w') as f:
    	
		write = csv.writer(f)

		write.writerow(header)
		write.writerow(line1)
		write.writerow(line2)
		write.writerow(line3)
		write.writerow(line4)
		write.writerow(line5)

		f.close()


exportResults(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4], sys.argv[5], sys.argv[6], sys.argv[7], sys.argv[8], sys.argv[9], sys.argv[10])


