#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Dec 12 10:40:46 2024

@author: josephhuang
"""

import datetime
import numpy as np
from numpy import cos, pi, sin
from scipy.interpolate import RegularGridInterpolator
from netCDF4 import Dataset
import cmath
import scipy.io
import pandas as pd
waves = ['M2','S2','N2','K1','O1','P1']
dc_freq = [1.9322736168,2.0,1.895981969,1.002737909,0.929535705,0.997262091] # in cycles per day
dc_phase = [1.7319,0.0,6.050618023,0.172994524,1.558431243,-0.172984130] # at jc_T0 in radians
jc_T0 = 15340 # date ref= (1992, 1, 1, 0, 0, 0) 距离 1950-01-01 00:00:00 的天数

# test Jc_T0
time_pt = datetime.datetime(1992, 1, 1, 0, 0, 0) -  datetime.datetime(1950,1,1,0,0,0)
time_ini = time_pt.total_seconds() / (24 * 3600)

#%%
# Extract data

filename = "../MIOST_OI_1_M2_formatCF.nc"

with Dataset(filename,'r') as data:
    lat = data.variables['lat'][:]
    lon = data.variables['lon'][:]
    amplitude = data.variables['amplitude'][:] # in cm
    phase = data.variables['phase'][:]

       
r_mod = 100.* amplitude * cos(-phase * pi/180.) # real elevation in m
i_mod = 100.* amplitude * sin(-phase * pi/180.) # imaginary elevation in m

#%% intepolation
Model_Grid = scipy.io.loadmat('../../BC_tide_SSHA_16N.mat')
lonm = Model_Grid['lon']
lat_transect = Model_Grid['lat']
lonm = np.squeeze(lonm)
latm = np.zeros_like(lonm) + lat_transect[0,0]
lonm = lonm+360

interpolator_x = RegularGridInterpolator((lat, lon), r_mod,bounds_error=False,fill_value=99999.)
interpolator_y = RegularGridInterpolator((lat, lon), i_mod,bounds_error=False,fill_value=99999.)

tidex = interpolator_x((latm,lonm))
tidey = interpolator_y((latm,lonm))

#%%
amp_tide = abs(tidex+tidey*1j)
#phi_tide = np.array([-cmath.phase(tidex[t]+tidey[t]*1j)*180./pi for t in np.arange(len(tidex))])
#phi_tide = -cmath.phase(tidex+tidey*1j)*180./pi
phi_tide = np.zeros_like(amp_tide)
for i in range(0,np.size(tidex,0)):
        phi_tide[i] = -cmath.phase(tidex[i]+tidey[i]*1j)*180./pi
        
#phi_tide = np.array([-cmath.phase(tidex[t]+tidey[t]*1j)*180./pi for t in np.arange(len(tidex))])
phi_tide = phi_tide % 360

# Select waves
freq = dc_freq[0]
phi = dc_phase[0]
# Select time
time_pt = datetime.datetime(2011,8,14,18,0,0) -  datetime.datetime(1950,1,1,0,0,0)
time_model = time_pt.total_seconds() / (24 * 3600)

tide_p = []
for i in np.arange(len(amp_tide)):

    amplitude_p = np.array(amp_tide)[i]
    phase_p = np.array(phi_tide)[i]*pi/180.

    tide = amplitude_p * cos( 2.*pi*(time_model-jc_T0)*freq - (phase_p-phi) )
    tide_p.append(tide)

#%%
tide_p = np.array(tide_p)* 0.01 # convert in cm
tide_p[np.isnan(tide_p)]=0

df = pd.DataFrame(tide_p)

# 指定输出文件路径和文件名
output_file = "MIOST_IT_Model_16N.xlsx"  # 或使用 .xlsx 格式

# 将 DataFrame 保存为 Excel 文件
df.to_excel(output_file, index=False, header=False)






