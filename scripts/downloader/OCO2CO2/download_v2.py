# -*- coding: utf-8 -*-
"""
Created on Tue Apr  6 16:35:01 2021

@author: Henock
"""



'''
This script downloads OCO2 XCO2 data given year and month
by Chongya Jiang in Dec, 2017

Usage: python Download.py year month user password 
e.g. : python Download.py 2017 7 xxx 123456
'''
  
import sys
import os
import urllib as urllib2
import datetime

ROOT = 'https://oco2.gesdisc.eosdis.nasa.gov/data/s4pa/OCO2_DATA/OCO2_L2_Lite_FP.9r'
root = '/bess19/Yulin/Data/OCO2CO2/'


time = datetime.datetime.now()
year = time.year
month = time.month


for  i in range(1,month-1): 
    
    
# def main(argv):
    # year = int(argv[0])
    # month = int(argv[1])
    
    month = i    
    USER = 'hiik324'
    PASSWORD = 'Ecology123'
    
    YEAR = '%d' % (year)
    MONTH = '%02d' % (month)
    path = os.path.join(root,YEAR)
    if not os.path.exists(path):
        os.mkdir(path)
    print ('Downloading OCO2_L2_Lite_FP.9r, ' + YEAR + MONTH)
    PATH = '%s/%d' % (ROOT,year)
    print(PATH)
    try:
        response = urllib2.urlopen(PATH)
        for line in response.readlines():
            ind = line.find('.nc4"><')
            if ind > 0: 
                name = line[ind-38:ind+4]
                URL = '%s/%s' % (PATH,name)
                url = '%s/%s' % (path,name)
               
                print (URL)
                os.system('wget --user %s --password %s -q -nc -O %s %s ' % (USER,PASSWORD,url,URL))
    except: 
        pass 
     
    
    