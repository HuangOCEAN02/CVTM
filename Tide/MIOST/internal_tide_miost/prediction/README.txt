===============
ITPrediction.py
===============

This python script computes the internal tide predictions from MIOST-IT
model on given latitude, longitude and time points and creates a netCDF
file that contains the predictions.

The user must give an ascii file containing the points positions in
space and time, the work directory and the list of waves for which the predictions
will be computed.

WARNING: The MIOST-IT grids must be in /work_directory/DATA/
         The predictions will be created in /work_directory/PREDICTIONS/
         The ascii file must not contain a header

Usage:
=====

python ITPrediction.py argument1 argument2 argument3

argument1: ascii file (column 1: time in days since 1950-01-01,
                       column 2: latitude in degree North [-90:90], 
                       column 3: longitude in degree East [0:360])
argument2: work directory
argument3: list of waves to take into account in the tidal prediction (can be one or several waves from : M2,S2,K1,O1)

Example:
========

python ITPrediction.py /path/ascii_file.txt /path/work_directory/ M2,K1

--------------------------------------------------------------------------

Python version used: Python 2.7.12
===================

Test:
=====

>> python ITPrediction.py MeasureDumpGUI_J3_T61_C20.txt ./ M2,K1,O1,S2

File created: PREDICTIONS/IT_prediction_M2+K1+O1+S2.nc


The prediction/ directory distributed on AVISO ftp contains 4 files:
====================================================================
- ITPrediction.py : prediction code
- MeasureDumpGUI_J3_T61_C20.txt : example of ascii file to use as argument1
- IT_prediction_M2+K1+O1+S2.nc : output file created by the prediction code if using the example ascii file above
- README.txt : this readme file

