# -*- coding: utf-8 -*-
"""
Created on Mon Jul 19 10:51:35 2021

@author: Henock
"""


import os
import modapsclient
from datetime import datetime
from datetime import timedelta 
import sys

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

products=["MCD12C1","MCD15A3H","MCD43D59","MCD43D60","MCD43D61","MCD43D62",
          "MCD43D63","MOD15A2H","MOD44B"]


for product in products:
    print("Downloading -> ", product)
    try:
        for day in range (int((enddate_obj - startdate_obj).days)):
            temp= startdate_obj + timedelta(days=day)  
            
            doy = int(datetime(temp.year,temp.month,temp.day).timetuple().tm_yday) 
            
            path_= os.path.join( path,product, str(temp.year),str(doy))
        
            if not os.path.exists(path_):
                print(path_)
                os.makedirs(path_)
             
            a = modapsclient.ModapsClient()
            
            
            items=a.searchForFiles(products=product, startTime=startdate, 
                                      endTime=enddate, north=north,south=south,
                                      west=west,east=east, collection=collection)
            print("Products count = > ",len(items))
        
        
            # for p in items:
            #     url=a.getFileUrls(p)[0]
            #     print(p,url) 
            #     cmd=('wget  --user hiik324 --password Ecology123 {0} --header "Authorization: Bearer C88B2F44-881A-11E9-B4DB-D7883D88392C" -P {1} '.format( url, path_))
            #     os.system(cmd)
    except:
        print("Error")
        print("Unexpected error:", sys.exc_info()[0])