

'''
This script downloads MOD15A2H data given year and month
by Chongya Jiang in Sep, 2018
 
Usage: python Download.py year month day
e.g. : python Download.py 2017 7 12
''' 

import os
from sys import argv
from datetime import datetime
import urllib as urllib2
import urllib.request
import sys

ROOT = 'https://e4ftl01.cr.usgs.gov/MOLT/MOD15A2H.006'
root = '/bess19/Yulin/Data/MOD15A2H/'
time = datetime.now()
year =time.year       
#year = int(year)

month = int(argv[2])
day = int(argv[3])
doy = int(datetime(year,month,day).timetuple().tm_yday)
YEAR = '%d' % (year)
MONTH = '%02d' % (month)
DOY = '%03d' % (doy)
#path = os.path.join(root,YEAR,DOY)

path = '%s%s/%s' %(root,YEAR,DOY)

if not os.path.exists(path): os.makedirs(path)
PATH = '%s/%d.%02d.%02d' % (ROOT,year,month,day) 

print('Downloading MOD15A2H, ' + YEAR + DOY)
try:  
    response = urllib2.request.urlopen(PATH) 
    print(PATH)
    for line in response.readlines():
        line = str(line)
        if not '.hdf">' in line: continue
        ind = line.find('.hdf">')
        name = line[:ind].split('"')[-1] + '.hdf'
        URL = '%s/%s' % (PATH,name)
        url = '%s/%s' % (path,name)
        print(url)
        os.system('wget -q -nc -c -O %s %s --user hiik324 --password Ecology123' %  (url, URL))
        
except:
    print('ERR',sys.exc_info()[0])
