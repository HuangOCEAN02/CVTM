#! /usr/bin/env python -t
# -*- coding: utf-8 -*-

"""
This script computes the internal tides predictions using MIOST-IT grids.
WARNING: The MIOST-IT grids must be in /work_directory/DATA/
         The predictions will be created in /work_directory/PREDICTIONS/
         The ascii file must not contain header

Usage:
=====

python ITPrediction.py argument1 argument2 argument3

argument1: ascii file (column 1: time in days since 1950-01-01,
                       column 2: latitude in degree North [-90:90], 
                       column 3: longitude in degree East [0:360])
argument2: work directory
argument3: waves to take into account in the tidal prediction

Example:
========

python ITPrediction.py /path/file.txt /path/work_directory/ M2,K1
 
"""

__author__ = 'ML Dabat / CLS - AVISO'
__update__ = '28/06/2021'

# Importation ---------

import argparse
import datetime
import numpy as np
import sys
import os,glob
from netCDF4 import Dataset
from numpy import cos, pi, sin
from scipy.interpolate import RegularGridInterpolator
import matplotlib.pyplot as plt
import cmath

# Initialisation --------

waves = ['M2','S2','N2','K1','O1','P1']
dc_freq = [1.9322736168,2.0,1.895981969,1.002737909,0.929535705,0.997262091] # in cycles per day
dc_phase = [1.7319,0.0,6.050618023,0.172994524,1.558431243,-0.172984130] # at jc_T0 in radians
jc_T0 = 15340 # date ref= (1992, 1, 1, 0, 0, 0)

# Arguments ---------

args = sys.argv
f_ascii = args[1]
directory = args[2]
waves_in = args[3].split(',')

# Extract data from ascii file  --------

print('Extract positions')

with open(f_ascii,'r') as f:
    lines = f.readlines()
    lat_pt = []
    lon_pt = []
    time_pt = []
    for line in lines:
        lat_pt.append(float(line.split('\t')[1]))
        lon_pt.append(float(line.split('\t')[2]))
        time_pt.append(float(line.split('\t')[0]))

# Internal tide prediction ---------

print('Compute internal tide predictions')

tide_w = []
tide_w_maj = []
for w in waves_in:
    
    # Extract data

    filename = directory + "DATA/MIOST_OI_1_" + w + "_formatCF.nc"

    with Dataset(filename,'r') as data:
        lat = data.variables['lat'][:]
        lon = data.variables['lon'][:]
        amplitude = data.variables['amplitude'][:] # in cm
        phase = data.variables['phase'][:]
        
    # Grid interpolation on alti data

    r_mod = 100.* amplitude * cos(-phase * pi/180.) # real elevation in m
    i_mod = 100.* amplitude * sin(-phase * pi/180.) # imaginary elevation in m
    
    interpolator_x = RegularGridInterpolator((lat, lon), r_mod,bounds_error=False,fill_value=99999.)
    interpolator_y = RegularGridInterpolator((lat, lon), i_mod,bounds_error=False,fill_value=99999.)

    tidex = interpolator_x(zip(lat_pt,lon_pt))
    tidey = interpolator_y(zip(lat_pt,lon_pt))

    amp_tide = abs(tidex+tidey*1j)
    phi_tide = np.array([-cmath.phase(tidex[t]+tidey[t]*1j)*180./pi for t in np.arange(len(tidex))])
    phi_tide = phi_tide % 360
    
    # Select waves

    idx_wave = np.where(np.array(waves) == w)[0][0]
    freq = dc_freq[idx_wave]
    phi = dc_phase[idx_wave]
    
    # Compute tide

    tide_p = []
    for i in np.arange(len(amp_tide)):

        amplitude_p = np.array(amp_tide)[i]
        phase_p = np.array(phi_tide)[i]*pi/180.

        tide = amplitude_p * cos( 2.*pi*(time_pt[i]-jc_T0)*freq - (phase_p-phi) )
        tide_p.append(tide)
        
    tide_w.append(tide_p)
    
tide_w = np.array(tide_w) * 0.01 # convert in cm

# Sum of all waves predictions

tide_t = []
for k in np.arange(np.shape(tide_w)[1]):
    
    idx1 = np.where(np.isnan(tide_w[:,k]) == True)[0]
        
    if len(idx1) == len(waves_in):
        tide_t.append(np.nan)
        
    else:
        if len(idx1) != 0:
            tide_w[idx1,k] = 0.
        tide_t.append(np.sum(tide_w[:,k]))

# Write predictions in netCDF file --------

if not os.path.exists(directory+"PREDICTIONS"):
    os.makedirs(directory+"PREDICTIONS")

output = directory + "PREDICTIONS/IT_prediction_"+"+".join(waves_in)+".nc"

with Dataset(output,'w',data_model='NETCDF4CLASSIC') as fout:

    # Dimensions
    
    nbpoint = len(tide_t)
    for dim, d_taille in (('nbpoint',nbpoint),):
        fout.createDimension(dim,size=d_taille)
    
    # Global attributes
    
    for name,attr in (('title','Internal tide prediction'),
                      ('date_created',datetime.datetime.today().strftime('%Y-%m-%d %H:%M:%S')),
                      ('history',datetime.datetime.today().strftime('%Y-%m-%d %H:%M:%S')+':creation'),):
        fout.setncattr(name,attr)

    # Variables
    
    for name,values,dtype,dimensions,long_name,units in (
            ('lat',lat_pt,'f8',('nbpoint',),"latitude","degrees_north"),
            ('lon',lon_pt,'f8',('nbpoint',),"longitude","degrees_east"),
            ('time',time_pt,'f8',('nbpoint',),"time","days since 1950-01-01"),
            ('tide',tide_t,'f8',('nbpoint',),"tide","cm"),):
        var = fout.createVariable(name,dtype,dimensions=dimensions)
        var.setncattr('long_name', long_name)
        var.setncattr('units',  units)
        var[:] = values

print("Creation: "+output)
