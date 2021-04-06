

import os
from datetime import datetime
import threading 



# make sure the system time is correct 
# os.system('sudo ntpdate time.nist.gov')
time = datetime.now()
year =time.year


path ="~/../../bess19/Yulin/Data"

def f1():
    os.system('cd {}/Aqua_L2'.format(path)) 
    os.system('find . -size 0 -delete')  
    os.system('nohup matlab -nodisplay <{}/Aqua_L2/Download_Aqua.m> log_Aqua.txt &'.format(path))

def f2():
    os.system('cd {}/Terra_L2'.format(path))
    os.system('find . -size 0 -delete')  
    os.system('nohup matlab -nodisplay <{}/Terra_L2/Download_Terra.m> log_Terra.txt &'.format(path))

def f3():
    os.system('cd {}/MCD12C1'.format(path))
    os.system('find . -size 0 -delete')  
    os.system('nohup python {}/MCD12C1/Download.py year hiik324 Ecology123 log_MCD12C1.txt &'.format(path))    
    
def f4():
    os.system('cd {}/MCD15A3H'.format(path))
    os.system('find . -size 0 -delete')  
    os.system('nohup python {}/MCD15A3H/Download_batch.py log_MCD15A3H.txt &'.format(path))
    
def f5():
    os.system('cd {}/MCD43D59'.format(path))
    os.system('find . -size 0 -delete')
    os.system('nohup python {}/MCD43D59/Download_batch.py log_MCD43D59.txt &'.format(path))  
        
def f6():
    os.system('cd {}/MCD43D60'.format(path))
    os.system('find . -size 0 -delete')
    os.system('nohup python {}/MCD43D60/Download_batch.py log_MCD43D60.txt &'.format(path))

def f7():
    os.system('cd {}/MCD43D61'.format(path))
    os.system('find . -size 0 -delete')
    os.system('nohup python {}/MCD43D61/Download_batch.py log_MCD43D61.txt &'.format(path))

def f8():
    os.system('cd {}/MCD43D62'.format(path))
    os.system('find . -size 0 -delete')
    os.system('nohup python {}/MCD43D62/Download_batch.py log_MCD43D62.txt &'.format(path))

def f9():
    os.system('cd {}/MCD43D63'.format(path))
    os.system('find . -size 0 -delete')
    os.system('nohup python {}/MCD43D63/Download_batch.py log_MCD43D63.txt &'.format(path))

def f10():
    os.system('cd {}/MOD15A2H'.format(path))
    os.system('find . -size 0 -delete')
    os.system('nohup python {}/MOD15A2H/Download_batch.py log_MOD15A2H.txt &'.format(path))

def f11():
    os.system('cd {}/MOD44B'.format(path))
    os.system('find . -size 0 -delete')
    os.system('nohup python {0}/MOD44B/Download.py year hiik324 Ecology123 > {0}/MOD44B/log_MOD44B.txt &'.format(path))

def f12():  
    os.system('cd '+ '{}/NOAACO2/'.format(path)) 
    os.system('find . -size 0 -delete')
    os.system('nohup python {}/NOAACO2/download_v2.py > {}/NOAACO2/log_NOAACO2.txt &'.format(path,path)) 
    
def f13():
    os.system('cd {}/OCO2CO2'.format(path))
    os.system('find . -size 0 -delete')
    os.system('nohup python {0}/OCO2CO2/Download_batch.py > {0}/OCO2CO2/log_OCO2CO2.txt &'.format(path))
    
def f14():
    os.system('cd {}/ERA5'.format(path))
    os.system('find . -size 0 -delete')
    # os.system('export PATH="/usr/local/python/3.6/bin:$PATH"')
    os.system('nohup python {0}/ERA5/Download_ERA5.py > {0}/ERA5/log_ERA5.txt &'.format(path))
    
def f15():
    os.system('cd {}/MERRA/GAS'.format(path))
    os.system('find . -size 0 -delete')
    # os.system('export PATH="/usr/local/python/3.6/bin:$PATH"')
    os.system('nohup python3 {0}/MERRA/GAS/download_v2.py > {0}/MERRA/GAS/log_GAS.txt &'.format(path))
    
def f16():
    os.system('cd {}/MERRA/SLV'.format(path))
    os.system('find . -size 0 -delete')
    # os.system('export PATH="/usr/local/python/3.6/bin:$PATH"')
    # os.system('export PATH="~/../../usr/local/anaconda3/bin/python:$PATH"')
    os.system('nohup python3 {0}/MERRA/SLV/Download.py > {0}/MERRA/GAS/log_SLV.txt &'.format(path))    
    
if __name__ == "__main__": 
    # create threads 

    # t1= threading.Thread(target=f1)
    # t2= threading.Thread(target=f2)
    # t3= threading.Thread(target=f3)
    # t4= threading.Thread(target=f4)
    # t5= threading.Thread(target=f5)
    # t6= threading.Thread(target=f6)
    # t7= threading.Thread(target=f7)
    # t8= threading.Thread(target=f8)
    # t9= threading.Thread(target=f9)
    # t10= threading.Thread(target=f10)
    # t11= threading.Thread(target=f11)
    # t12= threading.Thread(target=f12)
    t13= threading.Thread(target=f13)
    # t14= threading.Thread(target=f14)
    # t15= threading.Thread(target=f15)
    # t16= threading.Thread(target=f16)

    # t1.start()
    # t2.start()     
    # t3.start()
    # t4.start()
    # t5.start()
    # t6.start()
    # t7.start()
    # t8.start()
    # t9.start()
    # t10.start()
    # t11.start()
    # t12.start()
    t13.start()
    # t14.start()
    # t15.start()
    # t16.start()
    
    # t1.join()
    # t2.join()      
    # t3.join()
    # t4.join()
    # t5.join()
    # t6.join()
    # t7.join()
    # t8.join()
    # t9.join()
    # t10.join()
    # t11.join()
    # t12.join()
    t13.join()
    # t14.join()
    # t15.join()
    # t16.join()
    
  
    
#====================== Test =========================

print("Done")

#====================== Test =========================