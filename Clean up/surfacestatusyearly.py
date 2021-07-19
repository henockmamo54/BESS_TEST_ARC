# -*- coding: utf-8 -*-
"""
Created on Thu Jul 15 14:05:51 2021

@author: Henock
"""
 
import matlab.engine
import sys

   
def generate_all_surface_info_yearly(year) :

    print("Surface_status_info_generator Yearly\n","====><><><><><====== \n", year)
    
    
    eng = matlab.engine.start_matlab()
    
    years = [year,year+1]
    months= [1,2,3,4,5,6,7,8,9,10,11,12,1]
        
    
    for index in range(1,13):
    
        try:            
            print("1") 
            eng.f_ALB(years[int(index/12)], months[index],"VIS",nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
            
    for index in range(1,13):
        try:
            print("2")            
            eng.f_ALB(years[int(index/12)], months[index],"NIR",nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue            
    
    for index in range(1,13):    
        try:    
            print("3") 
            eng.f_ALB(years[int(index/12)], months[index],"SW",nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):    
        try:
            print("4") 
            eng.f_NDVI(years[int(index/12)], months[index],nargout=0)  
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:    
            print( "5 -0")
            eng.BESSRadiation(years[int(index/12)], months[index],nargout=0);
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    
    for index in range(1,13):    
        try:
            print("5")
            eng.f_EMIS(years[int(index/12)], months[index],nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):        
        try:
            print("6")
            eng.f_Averageindexly('RVIS_MCD^',years[int(index/12)],months[index]
                                 ,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
            
    for index in range(1,13):
        try:
            print("7")
            eng.f_Averageindexly('RNIR_MCD^',years[int(index/12)], months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
        
    
    for index in range(1,13):    
        try:
            eng.f_Averageindexly("RSW_MCD^",years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue    
        
    for index in range(1,13):
        try:
            print("8")
            eng.f_Averageindexly("NDVI_MCD^",years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
        
    for index in range(1,13):
        try:
            eng.f_Averageindexly("EMIS_MCD^",years[int(index/12)],
                                months[index],0,nargout=0)                                        
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
     
    for index in range(1,13):                               
        try:
            print("9")
            eng.f_Variationindexly("RVIS_MCD^",years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    
    for index in range(1,13):
        try:         
            eng.f_Variationindexly("RNIR_MCD^",years[int(index/12)],
                                months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):    
        try:
            print("10")
            eng.f_Variationindexly("RSW_MCD^",years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("11")
            eng.f_Variationindexly("NDVI_MCD^",years[int(index/12)],
                                    months[index],0,nargout=0)  
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):    
        try:    
            print("12")
            eng.f_Variationindexly("EMIS_MCD^",years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):    
        try:
            print("12-1")
            eng.f_Variationindexly("RVIS_MCD^",years[int(index/12)],
                                    months[index],0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("13")
            eng.f_Variationindexly("RVIS_MCD^",years[int(index/12)],
                                    months[index],1,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("14")
            eng.f_RefDaily("RNIR",years[int(index/12)], months[index],0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
        
    for index in range(1,13):                    
        try:
            print("15")
            eng.f_RefDaily("RNIR",years[int(index/12)], months[index],1,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:    
            print("16-1")
            eng.f_RefDaily("RSW",years[int(index/12)],
                                    months[index],0,nargout=0)            
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue    
    
    for index in range(1,13):    
        try:
            print("16-3")
            eng.f_RefDaily("RSW",years[int(index/12)],
                                    months[index],1,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    
    for index in range(1,13):
        try:
            print("17")
            eng.f_RefDaily("NDVI",years[int(index/12)],
                                    months[index],0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    
    for index in range(1,13):        
        try:   
            print("18")
            eng.f_RefDaily("NDVI",years[int(index/12)],
                                    months[index],1,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    
    for index in range(1,13):
        try:
            print("19")								  
            eng.f_RefDaily("EMIS",years[int(index/12)],
                                    months[index],0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    
    for index in range(1,13):             
        try:
            print("19-2")
            eng.f_RefDaily("EMIS",years[int(index/12)],
                                    months[index],1,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    # ===============================================================
    # ===============================================================
    for index in range(1,13):
        try:
            print("19")								  
            eng.f_RefDaily("RVIS",years[int(index/12)],
                                    months[index],0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    
    for index in range(1,13):    
        try:
            print("19-2")
            eng.f_RefDaily("RVIS",years[int(index/12)],
                                    months[index],1,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    # ===============================================================
    # ===============================================================
    
    for index in range(1,13):
        try:
            print("20")						  
            eng.f_LAIFPAR(years[int(index/12)],
                                    months[index],'LAI',nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("21")
            eng.f_LAIFPAR(years[int(index/12)],
                                    months[index],'FPAR',nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    
    for index in range(1,13):
        try:
            print("22")
            eng.f_LAIFPARFilter('LAI_MCD^', years[int(index/12)],
                                    months[index],0,nargout=0)     
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("23")
            eng.f_LAIFPARFilter('FPAR_MCD^', years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue    
    
    for index in range(1,13):
        try:
            print("24")
            eng.f_Averageindexly('LAI_MCD_Filter^', years[int(index/12)],
                                    months[index],0,nargout=0)  
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue    
    
    for index in range(1,13):
        try:
            print("25")
            eng.f_Averageindexly('FPAR_MCD_Filter^', years[int(index/12)],
                                    months[index],0,nargout=0)  
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:            
            print("26")
            eng.f_Variationindexly('LAI_MCD_Filter^', years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("27")
            eng.f_Variationindexly('FPAR_MCD_Filter^', years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("28") 
            eng.f_LAIFPARDaily('LAI_MCD_Filter^', years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("28 - 2 ") 
            eng.f_LAIFPARDaily('FPAR_MCD_Filter^', years[int(index/12)],
                                    months[index],0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    
    for index in range(1,13):
        try:
            print("29")
            eng.f_LAIFPARFilter('LAI_MOD^', years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("30")
            eng.f_LAIFPARFilter('FPAR_MOD^', years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("31")
            eng.f_Averageindexly('LAI_MOD_Filter^', years[int(index/12)],
                                    months[index],2,nargout=0)    
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("32")
            eng.f_Averageindexly('FPAR_MOD_Filter^', years[int(index/12)],
                                    months[index],2,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):    
        try:
            print("33")
            eng.f_Variationindexly('LAI_MOD_Filter^', years[int(index/12)],
                                    months[index],2,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):    
        try:
            print("34")					  
            eng.f_Variationindexly('FPAR_MOD_Filter^', years[int(index/12)],
                                    months[index],2,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("35")
            eng.f_LAIFPARDaily('LAI_MOD_Filter^', years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):    
        try:
            print("35 - 1")								  
            eng.f_LAIFPARDaily('FPAR_MOD_Filter^', years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):    
        try:
            print("36 - 0")				  
            eng.f_NOAH(years[int(index/12)],
                                    months[index],0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):                        
        try:                         
            print("36")				  
            eng.f_LSTDay(years[int(index/12)],
                                    months[index],0,'MOD',nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("37")
            eng.f_LSTDay(years[int(index/12)],
                                    months[index],0,'MYD',nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("38")					  
            eng.f_LSTNight(years[int(index/12)], months[index],nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("39")
            eng.f_VTCI(years[int(index/12)], months[index],nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("40")
            eng.f_AMSR2(years[int(index/12)], months[index],nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    for index in range(1,13):
        try:
            print("41")
            eng.f_SMAP(years[int(index/12)], months[index],nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            continue
    
    # print("42")
    # eng.f_SMOS(year, index,nargout=0) 
    
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # print("43")
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # eng.f_SM0(year, index,nargout=0)         
    
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # print("44")
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # eng.f_SMDaily(year, index,nargout=0) 
    
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # print("45")
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # eng.f_Lag30('SM_Daily',year, index,nargout=0) 
        
                
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # print("46")
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # eng.f_LSTFill('LST_MOD^',year, index,0,nargout=0)  
    
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # print("47")
    # # # # # # # # # # # # # # # # # # # # # # # # # # # # eng.f_LSTFill('LST_MYD^',year, index,0,nargout=0) 
    
    print("done!!! -> index = ")
    eng.quit()   
     
generate_all_surface_info_yearly (2046)