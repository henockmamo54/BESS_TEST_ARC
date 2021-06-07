

import os
from datetime import datetime
import threading 
import os, os.path



# make sure the system time is correct 
# os.system('sudo ntpdate time.nist.gov')
time = datetime.now()
# year =time.year

year= 2020
path ="/bess19/Yulin/Data"


def removeEmptyFiles(path):
    path = path + "/2021"
    for root, _, files in os.walk(path):
        for f in files:
            fullpath = os.path.join(root, f)
            try:
                if os.path.getsize(fullpath) == 0:   #set file size in kb
                    print (fullpath,os.path.getsize(fullpath))
                    os.remove(fullpath)
            except WindowsError:
                print ("Error" + fullpath)
                
                
def f1():
    os.system('cd {}/Aqua_L2'.format(path)) 
    removeEmptyFiles('{}/Aqua_L2'.format(path))
    # os.system('nohup matlab -nodisplay <{0}/Aqua_L2/Download_Aqua.m> {0}/Aqua_L2/log_Aqua_yearly.txt &'.format(path))
    "nohup matlab -nodisplay -nodesktop -r \"try; cd ('{0}/Aqua_L2'); test({1}) ; catch; end; quit\"  > {0}/Aqua_L2/log_yearly.txt &".format(path,year)
    os.system("nohup matlab -nodisplay -nodesktop -r \"try; cd ('{0}/Aqua_L2'); Download_AquaYearly({1}) ; catch; end; quit\"  > {0}/Aqua_L2/log_yearly.txt &".format(path,year))

def f2():
    os.system('cd {}/Terra_L2'.format(path)) 
    removeEmptyFiles('{}/Terra_L2'.format(path)) 
    # os.system('find . -size 0 -delete')  
    # os.system('nohup matlab -nodisplay <{0}/Terra_L2/Download_Terra.m>  {0}/Terra_L2/log_Terra_yearly.txt &'.format(path))
    os.system("nohup matlab -nodisplay -nodesktop -r \"try; cd ('{0}/Terra_L2'); Download_TerraYearly({1}) ; catch; end; quit\"  > {0}/Terra_L2/log_yearly.txt &".format(path,year))

def f3():
    os.system('cd {}/MCD12C1'.format(path)) 
    removeEmptyFiles('{}/Terra_L2'.format(path)) 
    # os.system('find . -size 0 -delete')  
    os.system('nohup python {0}/MCD12C1/DownloadYearly.py {1} hiik324 Ecology123 > {0}/MCD12C1/log_MCD12C1_yearly.txt &'.format(path,year))    
    
def f4():
    os.system('cd {}/MCD15A3H'.format(path)) 
    removeEmptyFiles('{}/MCD15A3H'.format(path)) 
    # os.system('find . -size 0 -delete')  
    os.system('nohup python3 {0}/MCD15A3H/Download_batchYearly.py {1} > {0}/MCD15A3H/log_MCD15A3H_yearly.txt &'.format(path,year))
    
def f5():
    os.system('cd {}/MCD43D59'.format(path)) 
    removeEmptyFiles('{}/MCD43D59'.format(path)) 
    # os.system('find . -size 0 -delete')
    os.system('nohup python {0}/MCD43D59/Download_batchYearly.py {1} > {0}/MCD43D59/log_MCD43D59_yearly.txt &'.format(path,year))  
        
def f6():
    os.system('cd {}/MCD43D60'.format(path)) 
    removeEmptyFiles('{}/MCD43D60'.format(path)) 
    # os.system('find . -size 0 -delete')
    os.system('nohup python {0}/MCD43D60/Download_batchYearly.py {1} >  {0}/MCD43D60/log_MCD43D60_yearly.txt &'.format(path,year))

def f7():
    os.system('cd {}/MCD43D61'.format(path)) 
    removeEmptyFiles('{}/MCD43D61'.format(path)) 
    # os.system('find . -size 0 -delete')
    os.system('nohup python {0}/MCD43D61/Download_batchYearly.py {1} > {0}/MCD43D61/log_MCD43D61_yearly.txt &'.format(path,year))

def f8():
    os.system('cd {}/MCD43D62'.format(path)) 
    removeEmptyFiles('{}/MCD43D62'.format(path)) 
    # os.system('find . -size 0 -delete')
    os.system('nohup python {0}/MCD43D62/Download_batchYearly.py {1} > {0}/MCD43D62/log_MCD43D62_yearly.txt &'.format(path,year))

def f9():
    os.system('cd {}/MCD43D63'.format(path)) 
    removeEmptyFiles('{}/MCD43D63'.format(path)) 
    # os.system('find . -size 0 -delete')
    os.system('nohup python {0}/MCD43D63/Download_batchYearly.py {1} > {0}/MCD43D63/log_MCD43D63_yearly.txt &'.format(path,year))

def f10():
    os.system('cd {}/MOD15A2H'.format(path)) 
    removeEmptyFiles('{}/MOD15A2H'.format(path)) 
    # os.system('find . -size 0 -delete')
    os.system('nohup python3 {0}/MOD15A2H/download_batch_v2Yearly.py {1} > {0}/MOD15A2H/log_MOD15A2H_yearly.txt &'.format(path,year))

def f11():
    os.system('cd {}/MOD44B'.format(path)) 
    removeEmptyFiles('{}/MOD44B'.format(path)) 
    # os.system('find . -size 0 -delete')
    os.system('nohup python {0}/MOD44B/DownloadYearly.py {1} year hiik324 Ecology123 > {0}/MOD44B/log_MOD44B_yearly.txt &'.format(path,year))

def f12():  
    os.system('cd '+ '{}/NOAACO2/'.format(path))  
    removeEmptyFiles('{}/NOAACO2/'.format(path))  
    # os.system('find . -size 0 -delete')
    os.system('nohup python {}/NOAACO2/download_v2.py > {}/NOAACO2/log_NOAACO2_yearly.txt &'.format(path,path)) 
    
def f13():
    os.system('cd {}/OCO2CO2'.format(path)) 
    removeEmptyFiles('{}/OCO2CO2'.format(path))
    # os.system('find . -size 0 -delete')
    os.system('nohup python {0}/OCO2CO2/Download_batchYearly.py {1} > {0}/OCO2CO2/log_OCO2CO2_yearly.txt &'.format(path,year))
    
def f14():
    os.system('cd {}/ERA5'.format(path)) 
    removeEmptyFiles('{}/ERA5'.format(path)) 
    # os.system('find . -size 0 -delete')
    # os.system('export PATH="/usr/local/python/3.6/bin:$PATH"')
    os.system('nohup python {0}/ERA5/Download_ERA5Yearly.py {1} > {0}/ERA5/log_ERA5_yearly.txt &'.format(path,year))
    
def f15():
    os.system('export PATH="/usr/local/anaconda3/bin/python:$PATH"')
    os.system('cd {}/MERRA/GAS'.format(path)) 
    removeEmptyFiles('{}/MERRA/GAS'.format(path)) 
    # os.system('find . -size 0 -delete')
    # os.system('export PATH="/usr/local/python/3.6/bin:$PATH"')
    os.system('nohup python3 {0}/MERRA/GAS/download_v2Yearly.py {1} > {0}/MERRA/GAS/log_GAS_yearly.txt &'.format(path,year))
    
def f16():
    os.system('export PATH="/usr/local/anaconda3/bin/python:$PATH"')
    os.system('cd {}/MERRA/SLV'.format(path)) 
    removeEmptyFiles('{}/MERRA/SLV'.format(path)) 
    # os.system('find . -size 0 -delete')
    # os.system('export PATH="/usr/local/python/3.6/bin:$PATH"')
    os.system('nohup python3 {0}/MERRA/SLV/download_v2Yearly.py {1}  > {0}/MERRA/SLV/log_SLV_yearly.txt &'.format(path,year)) 
    

def f17():  
    os.system('cd '+ '{}/NOAH3H21/'.format(path))  
    removeEmptyFiles('{}/NOAH3H21/'.format(path))  
    # os.system('find . -size 0 -delete')
    print('nohup python {0}/NOAH3H21/Download_batchYearly.py {1} > {0}/NOAH3H21/log_NOAH3H21_yearly.txt &'.format(path,year))
    os.system('nohup python {0}/NOAH3H21/Download_batchYearly.py {1} > {0}/NOAH3H21/log_NOAH3H21_yearly.txt &'.format(path,year)) 
    
    
if __name__ == "__main__": 
    # create threads 
    

    t1= threading.Thread(target=f1)
    t2= threading.Thread(target=f2)
    t3= threading.Thread(target=f3)
    t4= threading.Thread(target=f4)
    t5= threading.Thread(target=f5)
    t6= threading.Thread(target=f6)
    t7= threading.Thread(target=f7)
    t8= threading.Thread(target=f8)
    t9= threading.Thread(target=f9)
    t10= threading.Thread(target=f10)
    t11= threading.Thread(target=f11)
    t12= threading.Thread(target=f12)
    t13= threading.Thread(target=f13)
    t14= threading.Thread(target=f14)
    t15= threading.Thread(target=f15)
    t16= threading.Thread(target=f16)
    t17= threading.Thread(target=f17)

    t1.start()
    t2.start()     
    t3.start()
    t4.start()
    t5.start()
    t6.start()
    t7.start()
    t8.start()
    t9.start()
    t10.start()
    t11.start()
    t12.start()
    t13.start()
    t14.start()
    t15.start()
    t16.start()
    t17.start()
    
    t1.join()
    t2.join()      
    t3.join()
    t4.join()
    t5.join()
    t6.join()
    t7.join()
    t8.join()
    t9.join()
    t10.join()
    t11.join()
    t12.join()
    t13.join()
    t14.join()
    t15.join()
    t16.join()
    t17.join()
    
  
    
#====================== Test =========================

print("Done")

#====================== Test =========================