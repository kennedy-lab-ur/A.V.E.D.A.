#!/usr/bin/env python

import sys
import __main__
import sys, time, os
import pymol
import numpy as np

__main__.pymol_argv = [ 'pymol', '-qc'] # Quietly load
pymol.finish_launching()




reOrderCenterXYZ(sys.argv[1], sys.argv[2])






