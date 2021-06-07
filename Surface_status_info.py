# -*- coding: utf-8 -*-
"""
Created on Mon Mar 22 12:50:15 2021

@author: Henock
"""

import os
import sys
import matlab.engine
import BESS_Object


class Surface_status_info:
    
    def __init__(self,_bessObject):
        self._bessObject=_bessObject
        print("Surface_status_info")
        
    def generate_all_surface_info(self):
        print("Surface_status_info")
        
        eng = matlab.engine.start_matlab()
        
        try:
            print("1")
            eng.f_ALB(self._bessObject.Year,self._bessObject.Month,"VIS",nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("2")
            eng.f_ALB(self._bessObject.Year,self._bessObject.Month,"NIR",nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:    
            print("3")
            eng.f_ALB(self._bessObject.Year,self._bessObject.Month,"SW",nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("4")
            eng.f_NDVI(self._bessObject.Year,self._bessObject.Month,nargout=0)  
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:    
            print("4 - 2")
            if(self._bessObject.Month == 12):
                eng.f_NDVI(self._bessObject.Year+1,1,nargout=0)
            else:
                eng.f_NDVI(self._bessObject.Year,self._bessObject.Month+1,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:    
            print("4 - 3")
            if(self._bessObject.Month == 12):
                eng.f_NDVI(self._bessObject.Year+1,2,nargout=0)
            elif(self._bessObject.Month == 11):
                eng.f_NDVI(self._bessObject.Year+1,1,nargout=0)
            else:
                eng.f_NDVI(self._bessObject.Year,self._bessObject.Month+2,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
       
        # try:    
        #     print( "5 -0")
        #     eng.BESSRadiation(self._bessObject.Year,self._bessObject.Month,nargout=0);
        # except:
        #     print("Unexpected error:", sys.exc_info()[0])
        
        # try:
        #     print( "5 -01")
        #     if(self._bessObject.Month == 12):
        #         eng.BESSRadiation(self._bessObject.Year+1,1,nargout=0)
        #     else:
        #         eng.BESSRadiation(self._bessObject.Year,self._bessObject.Month+1,nargout=0);
        # except:
        #     print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("5")
            eng.f_EMIS(self._bessObject.Year,self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("5 - 2")
            if(self._bessObject.Month == 12):
                eng.f_EMIS(self._bessObject.Year+1,1,nargout=0)
            else:
                eng.f_EMIS(self._bessObject.Year,self._bessObject.Month+1,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        
        try:
            print("6")
            eng.f_AverageMonthly('RVIS_MCD^',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        
        try:
            print("7")
            eng.f_AverageMonthly('RNIR_MCD^',self._bessObject.Year,self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
            
        try:
            eng.f_AverageMonthly("RSW_MCD^",self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("8")
            eng.f_AverageMonthly("NDVI_MCD^",self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            eng.f_AverageMonthly("EMIS_MCD^",self._bessObject.Year,
        						  self._bessObject.Month,0,nargout=0)                                        
        except:
            print("Unexpected error:", sys.exc_info()[0])
                                        
        try:
            print("9")
            eng.f_VariationMonthly("RVIS_MCD^",self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:         
            eng.f_VariationMonthly("RNIR_MCD^",self._bessObject.Year,
        						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("10")
            eng.f_VariationMonthly("RSW_MCD^",self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("11")
            eng.f_VariationMonthly("NDVI_MCD^",self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0)  
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:    
            print("12")
            eng.f_VariationMonthly("EMIS_MCD^",self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("12-1")
            eng.f_VariationMonthly("RVIS_MCD^",self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("13")
            eng.f_VariationMonthly("RVIS_MCD^",self._bessObject.Year,
            						  self._bessObject.Month,1,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("14")
            eng.f_RefDaily("RNIR",self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
        #-----> the daily output requires next month data
            print("14-2")
            if(self._bessObject.Month == 12):
                eng.f_RefDaily("RNIR",self._bessObject.Year+1,
                                1,0,nargout=0)
            else:
                eng.f_RefDaily("RNIR",self._bessObject.Year,
        						  self._bessObject.Month+1,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
						  
        try:
            print("15")
            eng.f_RefDaily("RNIR",self._bessObject.Year,
            						  self._bessObject.Month,1,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:    
            print("16-1")
            eng.f_RefDaily("RSW",self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0)            
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("16-2")
            if(self._bessObject.Month == 12):
                eng.f_RefDaily("RSW",self._bessObject.Year+1,
            						  1,0,nargout=0)
            else:
                eng.f_RefDaily("RSW",self._bessObject.Year,
        						  self._bessObject.Month+1,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("16-3")
            eng.f_RefDaily("RSW",self._bessObject.Year,
            						  self._bessObject.Month,1,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("17")
            eng.f_RefDaily("NDVI",self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:                               
            print("17 - 2 ")
            if(self._bessObject.Month == 12):
                eng.f_RefDaily("NDVI",self._bessObject.Year+1,
            						  1,0,nargout=0)
            else:
                eng.f_RefDaily("NDVI",self._bessObject.Year,
            						  self._bessObject.Month+1,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:   
            print("18")
            eng.f_RefDaily("NDVI",self._bessObject.Year,
            						  self._bessObject.Month,1,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("19")								  
            eng.f_RefDaily("EMIS",self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("19-1")								  
            eng.f_RefDaily("EMIS",self._bessObject.Year,
            						  self._bessObject.Month+1,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("19-2")
            eng.f_RefDaily("EMIS",self._bessObject.Year,
            						  self._bessObject.Month,1,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("20")						  
            eng.f_LAIFPAR(self._bessObject.Year,
            						  self._bessObject.Month,'LAI',nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("21")
            eng.f_LAIFPAR(self._bessObject.Year,
            						  self._bessObject.Month,'FPAR',nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("22")
            eng.f_LAIFPARFilter('LAI_MCD^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0)     
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("23")
            eng.f_LAIFPARFilter('FPAR_MCD^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])    
        
        try:
            print("24")
            eng.f_AverageMonthly('LAI_MCD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0)  
        except:
            print("Unexpected error:", sys.exc_info()[0])
         
        try:
            print("25")
            eng.f_AverageMonthly('FPAR_MCD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0)  
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:            
            print("26")
            eng.f_VariationMonthly('LAI_MCD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("27")
            eng.f_VariationMonthly('FPAR_MCD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("28") 
            eng.f_LAIFPARDaily('LAI_MCD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("28 - 2 ") 
            eng.f_LAIFPARDaily('FPAR_MCD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("29")
            eng.f_LAIFPARFilter('LAI_MOD^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("30")
            eng.f_LAIFPARFilter('FPAR_MOD^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("31")
            eng.f_AverageMonthly('LAI_MOD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,2,nargout=0)    
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("32")
            eng.f_AverageMonthly('FPAR_MOD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,2,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("33")
            eng.f_VariationMonthly('LAI_MOD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,2,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        	
        try:
            print("34")					  
            eng.f_VariationMonthly('FPAR_MOD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,2,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("35")
            eng.f_LAIFPARDaily('LAI_MOD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("35 - 1")								  
            eng.f_LAIFPARDaily('FPAR_MOD_Filter^', self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("36 - 0")				  
            eng.f_NOAH(self._bessObject.Year,
            						  self._bessObject.Month,0,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
                                  
        try:                         
            print("36")				  
            eng.f_LSTDay(self._bessObject.Year,
            						  self._bessObject.Month,0,'MOD',nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("37")
            eng.f_LSTDay(self._bessObject.Year,
            						  self._bessObject.Month,0,'MYD',nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("38")					  
            eng.f_LSTNight(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("39")
            eng.f_VTCI(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("40")
            eng.f_AMSR2(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("41")
            eng.f_SMAP(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        # print("42")
        # eng.f_SMOS(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # print("43")
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # eng.f_SM0(self._bessObject.Year, self._bessObject.Month,nargout=0)         
        
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # print("44")
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # eng.f_SMDaily(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # print("45")
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # eng.f_Lag30('SM_Daily',self._bessObject.Year, self._bessObject.Month,nargout=0) 
        	
                	
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # print("46")
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # eng.f_LSTFill('LST_MOD^',self._bessObject.Year, self._bessObject.Month,0,nargout=0)  
        
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # print("47")
        # # # # # # # # # # # # # # # # # # # # # # # # # # # # eng.f_LSTFill('LST_MYD^',self._bessObject.Year, self._bessObject.Month,0,nargout=0) 
        
        eng.quit()   
    
        
    
    def validate():
        print("Validation") 
        

    def RVIS_MCD(self):
        # disp(sprintf('RVIS_MCD, d02d',year,month));  
        # f_ALB(year,month,'VIS');         
        eng = matlab.engine.start_matlab()
        
        eng.f_ALB(self._bessObject.Year,self._bessObject.Month,"VIS",nargout=0) 
        
        eng.quit()
        
    def RNIR_MCD (self):
        # disp(sprintf('RNIR_MCD, d02d',year,month));  
        # f_ALB(year,month,'NIR');
                
        eng = matlab.engine.start_matlab()
        
        eng.f_ALB(self._bessObject.Year,self._bessObject.Month,"NIR",nargout=0) 
        
        eng.quit()
        
    def RSW_MCD (self):
        # disp(sprintf('RSW_MCD, d02d',year,month));  
        # f_ALB(year,month,'SW');  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_ALB(self._bessObject.Year,self._bessObject.Month,"SW",nargout=0) 
        
        eng.quit()
        
    def NDVI_MCD (self):
        # disp(sprintf('NDVI_MCD, d02d',year,month));  
        # f_NDVI(year,month);   
        
        eng = matlab.engine.start_matlab()
        
        eng.f_NDVI(self._bessObject.Year,self._bessObject.Month,nargout=0) 
        
        eng.quit()
        
    def EMIS_MCD (self):                
        # disp(sprintf('EMIS_MCD, d02d',year,month));  
        # f_EMIS(year,month);  
    
        eng = matlab.engine.start_matlab()
        
        eng.f_EMIS(self._bessObject.Year,self._bessObject.Month,nargout=0) 
        
        eng.quit()
    
    def RVIS_MCD_Monthly (self): 
        # disp(sprintf('RVIS_MCD^_Monthly, d02d',year,month));   
        # f_AverageMonthly('RVIS_MCD^',year,month,0);
    
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('RVIS_MCD^',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
      
    def RNIR_MCD_Monthly (self): 
        # disp(sprintf('RNIR_MCD^_Monthly, d02d',year,month)); 
        # f_AverageMonthly('RNIR_MCD^',year,month,0);
    
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('RNIR_MCD^',self._bessObject.Year,self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
    def RSW_MCD_Monthly (self):         
        # disp(sprintf('RSW_MCD^_Monthly, d02d',year,month)); 
        # f_AverageMonthly('RSW_MCD^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly("RSW_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
    def NDVI_MCD_Monthly(self):
        # disp(sprintf('NDVI_MCD^_Monthly, d02d',year,month));   
        # f_AverageMonthly('NDVI_MCD^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly("NDVI_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
    
    def EMIS_MCD_Monthly (self):
        # disp(sprintf('EMIS_MCD^_Monthly, d02d',year,month));   
        # f_AverageMonthly('EMIS_MCD^',year,month,0);   
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly("EMIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
    def RVIS_MCD_Monthly0 (self):
        # disp(sprintf('RVIS_MCD^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('RVIS_MCD^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_VariationMonthly("RVIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
    def RNIR_MCD__Monthly0 (self):
        # disp(sprintf('RNIR_MCD^_Monthly0, d02d',year,month)); 
        # f_VariationMonthly('RNIR_MCD^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_VariationMonthly("RNIR_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
    def RSW_MCD_Monthly0 (self):
        # disp(sprintf('RSW_MCD^_Monthly0, d02d',year,month)); 
        # f_VariationMonthly('RSW_MCD^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_VariationMonthly("RSW_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
    
    def NDVI_MCD_Monthly0 (self):        
        # disp(sprintf('NDVI_MCD^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('NDVI_MCD^',year,month,0);    
        
        eng = matlab.engine.start_matlab()
        
        eng.f_VariationMonthly("NDVI_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
    
    def EMIS_MCD_Monthly0 (self):         
        # disp(sprintf('EMIS_MCD^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('EMIS_MCD^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_VariationMonthly("EMIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
    
    def RVIS_Daily (self): 
        # disp(sprintf('RVIS_Daily^, d02d',year,month)); 
        # f_RefDaily('RVIS_MCD^',year,month,0);     
        # f_RefDaily('RVIS_MCD^',year,month,1);  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_VariationMonthly("RVIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.f_VariationMonthly("RVIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,1,nargout=0) 
        
        eng.quit()
        
    def RNIR_Daily (self):  
        # disp(sprintf('RNIR_Daily^, d02d',year,month)); 
        # f_RefDaily('RNIR_MCD^',year,month,0);      
        # f_RefDaily('RNIR_MCD^',year,month,1); 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_RefDaily("RNIR_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.f_RefDaily("RNIR_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,1,nargout=0) 
        
        eng.quit()
        
    def RSW_Daily (self):
        # disp(sprintf('RSW_Daily^, d02d',year,month)); 
        # f_RefDaily('RSW_MCD^',year,month,0);   
        # f_RefDaily('RSW_MCD^',year,month,1);  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_RefDaily("RSW_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.f_RefDaily("RSW_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,1,nargout=0) 
        
        eng.quit()
        
        
    def NDVI_Daily (self):
        # disp(sprintf('NDVI_Daily^, d02d',year,month)); 
        # f_RefDaily('NDVI_MCD^',year,month,0);    
        # f_RefDaily('NDVI_MCD^',year,month,1); 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_RefDaily("NDVI_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.f_RefDaily("NDVI_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,1,nargout=0) 
        
        eng.quit()
        
        
    def EMIS_Daily (self): 
        # disp(sprintf('EMIS_Daily^, d02d',year,month)); 
        # f_RefDaily('EMIS_MCD^',year,month,0);   
        # f_RefDaily('EMIS_MCD^',year,month,1); 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_RefDaily("EMIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.f_RefDaily("EMIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,1,nargout=0) 
        
        eng.quit()
        
    def LAI (self):            
        # disp(sprintf('LAI',year,month));
        # f_LAIFPAR(year,month,'LAI')
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LAIFPAR(self._bessObject.Year,
                                  self._bessObject.Month,'LAI',nargout=0) 
        
        eng.quit()
    
    def FPAR (self):         
        # disp(sprintf('FPAR',year,month));
        # f_LAIFPAR(year,month,'FPAR')
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LAIFPAR(self._bessObject.Year,
                                  self._bessObject.Month,'FPAR',nargout=0) 
        
        eng.quit()
        
    def LAI_MCD_Filter (self): 
        # disp(sprintf('LAI_MCD_Filter^, d02d',year,month)); 
        # f_LAIFPARFilter('LAI_MCD^',year,month,0);     
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LAIFPAR('LAI_MCD^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
    def f_LAIFPARFilter (self):         
        # disp(sprintf('FPAR_MCD_Filter^, d02d',year,month)); 
        # f_LAIFPARFilter('FPAR_MCD^',year,month,0);   
        eng = matlab.engine.start_matlab()
        
        eng.f_LAIFPARFilter('FPAR_MCD^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()


    def LAI_MCD_Filter_Monthly (self):        
        # disp(sprintf('LAI_MCD_Filter^_Monthly, d02d',year,month));   
        # f_AverageMonthly('LAI_MCD_Filter^',year,month,0);   
         
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('LAI_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
    def FPAR_MCD_Filter_Monthly (self):         
        # disp(sprintf('FPAR_MCD_Filter^_Monthly, d02d',year,month));   
        # f_AverageMonthly('FPAR_MCD_Filter^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('FPAR_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
    def LAI_MCD_Filter_Monthly0 (self):
        # disp(sprintf('LAI_MCD_Filter^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('LAI_MCD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_VariationMonthly('LAI_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
        
    def FPAR_MCD_Filter_Monthly0 (self):        
        # disp(sprintf('FPAR_MCD_Filter^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('FPAR_MCD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_VariationMonthly('FPAR_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
    def LAI_Daily (self):
        # disp(sprintf('LAI_Daily^, d02d',year,month)); 
        # f_LAIFPARDaily('LAI_MCD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LAIFPARDaily('LAI_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
        
    def FPAR_Daily (self):
        # disp(sprintf('FPAR_Daily^, d02d',year,month)); 
        # f_LAIFPARDaily('FPAR_MCD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LAIFPARDaily('FPAR_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
        
    def LAI_MOD_Filter (self):         
        # disp(sprintf('LAI_MOD_Filter^, d02d',year,month)); 
        # f_LAIFPARFilter('LAI_MOD^',year,month,0);    
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LAIFPARFilter('LAI_MOD^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
    def FPAR_MOD_Filter (self): 
        # disp(sprintf('FPAR_MOD_Filter^, d02d',year,month)); 
        # f_LAIFPARFilter('FPAR_MOD^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LAIFPARFilter('FPAR_MOD^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit()
        
    def LAI_MOD_Filter_Monthly (self):
        # disp(sprintf('LAI_MOD_Filter^_Monthly, d02d',year,month));   
        # f_AverageMonthly('LAI_MOD_Filter^',year,month,2); 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LAIFPARFilter('LAI_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,2,nargout=0) 
        
        eng.quit()
    
    def FPAR_MOD_Filter_Monthly (self):        
        # disp(sprintf('FPAR_MOD_Filter^_Monthly, d02d',year,month));   
        # f_AverageMonthly('FPAR_MOD_Filter^',year,month,2); 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('FPAR_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,2,nargout=0) 
        
        eng.quit() 
        
    def LAI_MOD_Filter_Monthly0 (self): 
        # disp(sprintf('LAI_MOD_Filter^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('LAI_MOD_Filter^',year,month,2);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_VariationMonthly('LAI_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,2,nargout=0) 
        
        eng.quit() 
        
    def FPAR_MOD_Filter_Monthly0 (self):
        # disp(sprintf('FPAR_MOD_Filter^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('FPAR_MOD_Filter^',year,month,2);     

        eng = matlab.engine.start_matlab()
        
        eng.f_VariationMonthly('FPAR_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,2,nargout=0) 
        
        eng.quit() 
        
    def LAI_Daily (self):
        # disp(sprintf('LAI_Daily^, d02d',year,month)); 
        # f_LAIFPARDaily('LAI_MOD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LAIFPARDaily('LAI_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit() 
        
    def FPAR_Daily (self):
        # disp(sprintf('FPAR_Daily^, d02d',year,month)); 
        # f_LAIFPARDaily('FPAR_MOD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LAIFPARDaily('FPAR_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0) 
        
        eng.quit() 
        
    def LST_AM (self):         
        # disp(sprintf('LST_AM^, d02d',year,month)); 
        # f_LSTDay(year,month,0,'MOD'); 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LSTDay(self._bessObject.Year,
                                  self._bessObject.Month,0,'MOD',nargout=0) 
        
        eng.quit() 
        
    def LST_PM (self):         
        # disp(sprintf('LST_PM^, d02d',year,month)); 
        # f_LSTDay(year,month,0,'MYD'); 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LSTDay(self._bessObject.Year,
                                  self._bessObject.Month,0,'MYD',nargout=0) 
        
        eng.quit() 
        
    def LST_Night (self): 
        # disp(sprintf('LST_Night, d02d',year,month)); 
        # f_LSTNight(year,month);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_LSTNight(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        
        eng.quit() 
        
    def VTCI (self):
        # disp(sprintf('VTCI, d02d',year,month)); 
        # f_VTCI(year,month);

        eng = matlab.engine.start_matlab()
        
        eng.f_VTCI(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        
        eng.quit() 
        
    def AMSR2_SM (self): 
        # disp(sprintf('AMSR2-SM, d02d',year,month)); 
        # f_AMSR2(year,month);

        eng = matlab.engine.start_matlab()
        
        eng.f_AMSR2(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        
        eng.quit() 
        
        
    def SMAP_SM (self):
        # disp(sprintf('SMAP-SM, d02d',year,month)); 
        # f_SMAP(year,month);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_SMAP(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        
        eng.quit() 
        
    def SMOS_SM (self):
        # disp(sprintf('SMOS-SM, d02d',year,month)); 
        # f_SMOS(year,month); 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_SMOS(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        
        eng.quit() 
        
    def SM0 (self) :
        # disp(sprintf('SM0, d02d',year,month)); 
        # f_SM0(year,month);
        
        eng = matlab.engine.start_matlab()
        
        eng.f_SM0(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        
        eng.quit() 
        
    def SM_Daily (self):
        # disp(sprintf('SM_Daily, d02d',year,month)); 
        # f_SMDaily(year,month); 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_SMDaily(self._bessObject.Year, self._bessObject.Month,nargout=0) 
        
        eng.quit() 
        
    def SM_Lag30 (self):        
        # disp(sprintf('SM_Lag30, d02d',year,month)); 
        # f_Lag30('SM_Daily',year,month); 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_Lag30('SM_Daily',self._bessObject.Year, self._bessObject.Month,nargout=0) 
        
        eng.quit() 
        
    def LST_AM (self):        
        # disp(sprintf('LST_AM^, d02d',year,month)); 
        # f_LSTFill('LST_MOD^',year,month,0) 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_Lag30('LST_MOD^',self._bessObject.Year, self._bessObject.Month,0,nargout=0) 
        
        eng.quit() 
    
    def LST_PM (self):
        # disp(sprintf('LST_PM^, d02d',year,month)); 
        # f_LSTFill('LST_MYD^',year,month,0) 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_Lag30('LST_MYD^',self._bessObject.Year, self._bessObject.Month,0,nargout=0) 
        
        eng.quit() 
        