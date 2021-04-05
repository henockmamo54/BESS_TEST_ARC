###############################################################################
##
## Download NOAA daily and monthly surface CO2 data
##
###############################################################################

## 
#  This is not a real-time data. 
#  Year-round data might be updated in next summer.
#  Please check the website below to see if data have been updated or not.
#  How to use: python Download.py
#  


import os 
from datetime import datetime
root = '~/../../bess19/Yulin/Data/NOAACO2/'
PATH = 'ftp://aftp.cmdl.noaa.gov/data/trace_gases/co2/in-situ/surface'

print('\n ###############################################################################')
start=datetime.now()
print( "NOAACO2, start = ", start )

for site in ['brw','mlo','smo','spo']: 
    for scale in ['Monthly','Daily']:
        name = 'co2_%s_surface-insitu_1_ccgg_%sData.nc' % (site,scale)
        URL = os.path.join(PATH,site,name)
        cmd = 'wget -q -nc %s -O %s%s' % (URL, root, name)    # overwrite
        os.system(cmd)

end =datetime.now() 
print( "NOAACO2, end = ", end )
print('\n ###############################################################################')