# -*- coding: utf-8 -*-
"""
Created on Mon Jul 19 10:51:35 2021

@author: Henock
"""


import os
import sys
import numpy as np
import modapsclient
import urllib as urllib2
from datetime import datetime
from datetime import timedelta 

username = "hiik324"
password = "Ecology123"
startdate="2019-08-01"
enddate="2019-08-03"
# enddate="2020-01-01"

north="48.22346787684907"
south="38.18195837298332"
west="127.21710138948873"
east="128.27222505323994"
# product="MCD43A4"
collection="61"
 
startdate_obj = datetime.strptime(startdate, '%Y-%m-%d')
enddate_obj = datetime.strptime(enddate, '%Y-%m-%d') 
path = "D:/Workplace/githubProjects/BESS_TEST_ARC/Data"


def download_modis_products():
    products=["MCD12C1","MCD15A3H","MCD43D59","MCD43D60","MCD43D61","MCD43D62",
              "MCD43D63","MOD15A2H","MOD44B"]
    
    
    for product in products:
        print("Downloading -> ", product)
        try:
            for day in range (int((enddate_obj - startdate_obj).days)):
                temp= startdate_obj + timedelta(days=day)  
                
                doy = int(datetime(temp.year,temp.month,temp.day).timetuple().tm_yday) 
                
                if(product=='MOD44B'):
                    path_= os.path.join( path,product, str(temp.year))
                else:
                    path_= os.path.join( path,product, str(temp.year),str(doy))
            
                if not os.path.exists(path_):
                    print(path_)
                    os.makedirs(path_)
                 
                a = modapsclient.ModapsClient()
                
                
                items=a.searchForFiles(products=product, startTime=temp, 
                                          endTime=temp, north=north,south=south,
                                          west=west,east=east, collection=collection)
                print("Products count = > ",len(items))
            
            
                # for p in items:
                #     url=a.getFileUrls(p)[0]
                #     print(p,url) 
                #     # cmd=('wget  --user hiik324 --password Ecology123 {0} --header "Authorization: Bearer C88B2F44-881A-11E9-B4DB-D7883D88392C" -P {1} '.format( url, path_))
                #     cmd=('wget  --user hiik324 --password Ecology123 {0}  -P {1} '.format( url, path_))
                #     os.system(cmd)
        except:
            print("Error")
            print("Unexpected error:", sys.exc_info()[0])
            
def download_MCD12C1():
        
    ROOT = 'https://e4ftl01.cr.usgs.gov/MOTA/MCD12C1.006' #MODIS/Terra+Aqua Land Cover Type CMG Yearly L3 Global 0.05 Deg
     
    years= np.unique(np.array([startdate_obj.year,enddate_obj.year]))
    
    for year in years:    
       
        #year = int(year)
        USER = username
        PASSWORD = password
        YEAR = '%d' % (year)
        path_ = os.path.join(path,YEAR)
        if not os.path.exists(path_): os.makedirs(path_)
        print ('Downloading MCD12C1, ' + YEAR)
        PATH = '%s/%d.%02d.%02d' % (ROOT,year,1,1)
        try: 
            response = urllib2.urlopen(PATH)
            for line in response.readlines():
                ind = line.find('.hdf">')
                if ind > 0:
                    name = line[ind-34:ind+4]
                    URL = '%s/%s' % (PATH,name)
                    url = '%s/%s' % (path_,name)
                    print (URL)
                    os.system('wget --user %s --password %s -q -nc -O %s %s ' % (USER, PASSWORD, url,URL))
        except:
                pass
     


            
if __name__ == "__main__":
    # download_modis_products()
    download_MCD12C1()
