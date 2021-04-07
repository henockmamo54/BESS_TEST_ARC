# -*- coding: utf-8 -*-
"""
Created on Wed Apr  7 08:51:37 2021

@author: Henock
"""

import os
from calendar import monthrange        
import datetime
time = datetime.datetime.now()
year =time.year-1 #time lag one year
        
for year in [year]:#range(2000,2018):
    for month in range(1,13):#range(6,13):#range(1,13):
        monthdays = monthrange(year,month)[1]
        for day in range(1,32):
            if day > monthdays: continue
            os.system('python /bess19/Yulin/Data/MCD15A3H/download_v2.py %d %02d %03d' % (year,month,day))
            
