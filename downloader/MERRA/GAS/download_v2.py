# -*- coding: utf-8 -*-
"""
Created on Tue Apr  6 15:52:26 2021

@author: Henock
"""

import urllib
import os
from http.cookiejar import CookieJar
import datetime
import wget


# The user credentials that will be used to authenticate access to the data
time = datetime.datetime.now()
year = time.year

month = time.month
root = '/bess19/Yulin/Data/MERRA/GAS'


username = "hiik324"
password = "Ecology123"
  
password_mgr = urllib.request.HTTPPasswordMgrWithDefaultRealm()
 
for  i in range(1,month-1):
    

    url = "https://goldsmr4.gesdisc.eosdis.nasa.gov/data/MERRA2/M2I3NXGAS.5.12.4/%d/%02d/"% (year,i)
     
    password_manager = urllib.request.HTTPPasswordMgrWithDefaultRealm()
    password_manager.add_password(None, "https://urs.earthdata.nasa.gov", username, password)

    cookie_jar = CookieJar()

    opener = urllib.request.build_opener(
        urllib.request.HTTPBasicAuthHandler(password_manager),
        urllib.request.HTTPCookieProcessor(cookie_jar))
    urllib.request.install_opener(opener)



    response = urllib.request.urlopen(url)
    a = '.nc4"><'
    b = a.encode()
    
    MONTH = '%02d' % (i)
    YEAR ='%d' % (year)
    path = os.path.join(root,YEAR,MONTH)
    if not os.path.exists(os.path.join(root,YEAR)):
         os.mkdir(os.path.join(root,YEAR))
        
    if not os.path.exists(path): 
        os.mkdir(path)
    os.chdir(path)
    
    for line in response.readlines():
        ind = line.find(b)
        if ind > 0:
            name = line[ind-35:ind+4]
            name = name.decode()
            URL = '%s%s' % (url,name)
            #os.system('wget -q -nc -c -O %s %s' % (path, URL))
            print (path,name, URL)
            
            filename = path + '/'+ name
            if os.path.exists(filename):
                os.remove(filename) 
                    
            wget.download(URL, out=filename)