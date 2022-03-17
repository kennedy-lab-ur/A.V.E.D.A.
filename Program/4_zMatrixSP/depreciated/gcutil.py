# UTILITY TO CONVERT BETWEEN XYZ AND Z-MATRIX GEOMETRIES
# Copyright 2017 Robert A Shaw
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the Software
# is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#                                                   
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
# OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
# Utilities for gc.py

import numpy as np
from scipy.spatial.distance import cdist

def replace_vars(vlist, variables):
    for i in range(len(vlist)):
        if vlist[i] in variables:
            value = variables[vlist[i]]
            vlist[i] = value
        else:
            try:
                value = float(vlist[i])
                vlist[i] = value
            except:
                print("Problem with entry " + str(vlist[i]))

def readxyz(filename):
    xyzf = open(filename, 'r')
    xyzarr = np.zeros([1, 3])
    atomnames = []
    if not xyzf.closed:
        # Read the first line to get the number of particles
        npart = int(xyzf.readline())
        # and next for title card
        title = xyzf.readline()

        # Make an N x 3 matrix of coordinates
        xyzarr = np.zeros([npart, 3])
        i = 0
        for line in xyzf:
            words = line.split()
            if (len(words) > 3):
                atomnames.append(words[0])
                xyzarr[i][0] = float(words[1])
                xyzarr[i][1] = float(words[2])
                xyzarr[i][2] = float(words[3])
                i = i + 1
    return (xyzarr, atomnames)

def distance_matrix(xyzarr):
    return cdist(xyzarr, xyzarr)

def angle(xyzarr, i, j, k):
    rij = xyzarr[i] - xyzarr[j]
    rkj = xyzarr[k] - xyzarr[j]
    cos_theta = np.dot(rij, rkj)
    sin_theta = np.linalg.norm(np.cross(rij, rkj))
    theta = np.arctan2(sin_theta, cos_theta)
    theta = 180.0 * theta / np.pi
    return theta

def dihedral(xyzarr, i, j, k, l):
    rji = xyzarr[j] - xyzarr[i]
    rkj = xyzarr[k] - xyzarr[j]
    rlk = xyzarr[l] - xyzarr[k]
    v1 = np.cross(rji, rkj)
    v1 = v1 / np.linalg.norm(v1)
    v2 = np.cross(rlk, rkj)
    v2 = v2 / np.linalg.norm(v2)
    m1 = np.cross(v1, rkj) / np.linalg.norm(rkj)
    x = np.dot(v1, v2)
    y = np.dot(m1, v2)
    chi = np.arctan2(y, x)
    chi = -180.0 - 180.0 * chi / np.pi
    if (chi < -180.0):
        chi = chi + 360.0
    return chi

def write_zmat(xyzfilename, xyzarr, distmat, atomnames, rvar=False, avar=False, dvar=False):

    zExp = open(xyzfilename[:-4]+"_zmat.xyz", 'w')

    npart, ncoord = xyzarr.shape
    rlist = []
    alist = []
    dlist = []
    if npart > 0:
        # Write the first atom
        print(atomnames[0])
        zExp.write(atomnames[0]+"\n")
        if npart > 1:
            # and the second, with distance from first
            n = atomnames[1]
            rlist.append(distmat[0][1])
            if (rvar):
                r = 'R1'
            else:
                r = '{:>11.5f}'.format(rlist[0])
            print('{:<3s} {:>4d}  {:11s}'.format(n, 1, r))
            zExp.writelines('{:<3s} {:>4d}  {:11s}'.format(n, 1, r)+"\n")
            if npart > 2:
                n = atomnames[2]
                
                rlist.append(distmat[0][2])
                if (rvar):
                    r = 'R2'
                else:
                    r = '{:>11.5f}'.format(rlist[1])
                
                alist.append(angle(xyzarr, 2, 0, 1))
                if (avar):
                    t = 'A1'
                else:
                    t = '{:>11.5f}'.format(alist[0])

                print('{:<3s} {:>4d}  {:11s} {:>4d}  {:11s}'.format(n, 1, r, 2, t))
                zExp.writelines('{:<3s} {:>4d}  {:11s} {:>4d}  {:11s}'.format(n, 1, r, 2, t)+"\n")
                if npart > 3:
                    for i in range(3, npart):
                        n = atomnames[i]

                        rlist.append(distmat[i-3][i])
                        if (rvar):
                            r = 'R{:<4d}'.format(i)
                        else:
                            r = '{:>11.5f}'.format(rlist[i-1])

                        alist.append(angle(xyzarr, i, i-3, i-2))
                        if (avar):
                            t = 'A{:<4d}'.format(i-1)
                        else:
                            t = '{:>11.5f}'.format(alist[i-2])
                        
                        dlist.append(dihedral(xyzarr, i, i-3, i-2, i-1))
                        if (dvar):
                            d = 'D{:<4d}'.format(i-2)
                        else:
                            d = '{:>11.5f}'.format(dlist[i-3])
                        print('{:3s} {:>4d}  {:11s} {:>4d}  {:11s} {:>4d}  {:11s}'.format(n, i-2, r, i-1, t, i, d))
                        zExp.writelines('{:3s} {:>4d}  {:11s} {:>4d}  {:11s} {:>4d}  {:11s}'.format(n, i-2, r, i-1, t, i, d)+"\n")
    if (rvar):
        print(" ")
        zExp.write(" \n")
        for i in range(npart-1):
            print('R{:<4d} = {:>11.5f}'.format(i+1, rlist[i]))
            zExp.writelines( 'R{:<4d} = {:>11.5f}'.format(i+1, rlist[i])+"\n")
    if (avar):
        for i in range(npart-2):
            print('A{:<4d} = {:>11.5f}'.format(i+1, alist[i]))
            zExp.writelines( 'A{:<4d} = {:>11.5f}'.format(i+1, alist[i])+"\n")
    if (dvar):
        for i in range(npart-3):
            print('D{:<4d} = {:>11.5f}'.format(i+1, dlist[i]))
            zExp.writelines( 'D{:<4d} = {:>11.5f}'.format(i+1, dlist[i])+"\n")


    zExp.close()



