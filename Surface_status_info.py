# -*- coding: utf-8 -*-
"""
Created on Mon Mar 22 12:50:15 2021

@author: Henock
"""

import matlab.engine
import os
import BESS_Object


class Surface_status_info:
    
    def __init__(self,_bessObject):
        self._bessObject=_bessObject
        print("Surface_status_info")
        
    def generate_all_surface_info(self):
        print("Surface_status_info")
    
    def RVIS_Daily_RNIR_Daily_RSW_Daily(self):
        print("RVIS_Daily_RNIR_Daily_RSW_Daily")
        
    def FPAR_Daily_LAI_Daily_NDVI_Daily(self):
        print("FPAR_Daily_LAI_Daily_NDVI_Daily")
        
    def LST_AM_LST_PM(self):
        print("FPAR_Daily_LAI_Daily_NDVI_Daily")
        
    
    def validate():
        print("Validation") 
        

    def RVIS_MCD(self):
        # disp(sprintf('RVIS_MCD, d02d',year,month));  
        # f_ALB(year,month,'VIS');         
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_ALB(self._bessObject.Year,self._bessObject.Month,"VIS") 
        
        eng.quit()
        
    def RNIR_MCD (self):
        # disp(sprintf('RNIR_MCD, d02d',year,month));  
        # f_ALB(year,month,'NIR');
                
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_ALB(self._bessObject.Year,self._bessObject.Month,"NIR") 
        
        eng.quit()
        
    def RSW_MCD (self):
        # disp(sprintf('RSW_MCD, d02d',year,month));  
        # f_ALB(year,month,'SW');  
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_ALB(self._bessObject.Year,self._bessObject.Month,"SW") 
        
        eng.quit()
        
    def NDVI_MCD (self):
        # disp(sprintf('NDVI_MCD, d02d',year,month));  
        # f_NDVI(year,month);   
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_NDVI(self._bessObject.Year,self._bessObject.Month) 
        
        eng.quit()
        
    def EMIS_MCD (self):                
        # disp(sprintf('EMIS_MCD, d02d',year,month));  
        # f_EMIS(year,month);  
    
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_EMIS(self._bessObject.Year,self._bessObject.Month) 
        
        eng.quit()
    
    def RVIS_MCD_Monthly (self): 
        # disp(sprintf('RVIS_MCD^_Monthly, d02d',year,month));   
        # f_AverageMonthly('RVIS_MCD^',year,month,0);
    
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly('RVIS_MCD^',self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
      
    def RNIR_MCD_Monthly (self): 
        # disp(sprintf('RNIR_MCD^_Monthly, d02d',year,month)); 
        # f_AverageMonthly('RNIR_MCD^',year,month,0);
    
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly('RNIR_MCD^',self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
    def RSW_MCD_Monthly (self):         
        # disp(sprintf('RSW_MCD^_Monthly, d02d',year,month)); 
        # f_AverageMonthly('RSW_MCD^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly("RSW_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
    def NDVI_MCD_Monthly(self):
        # disp(sprintf('NDVI_MCD^_Monthly, d02d',year,month));   
        # f_AverageMonthly('NDVI_MCD^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly("NDVI_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
    
    def EMIS_MCD_Monthly (self):
        # disp(sprintf('EMIS_MCD^_Monthly, d02d',year,month));   
        # f_AverageMonthly('EMIS_MCD^',year,month,0);   
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly("EMIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
    def RVIS_MCD_Monthly0 (self):
        # disp(sprintf('RVIS_MCD^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('RVIS_MCD^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_VariationMonthly("RVIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
    def RNIR_MCD__Monthly0 (self):
        # disp(sprintf('RNIR_MCD^_Monthly0, d02d',year,month)); 
        # f_VariationMonthly('RNIR_MCD^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_VariationMonthly("RNIR_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
    def RSW_MCD_Monthly0 (self):
        # disp(sprintf('RSW_MCD^_Monthly0, d02d',year,month)); 
        # f_VariationMonthly('RSW_MCD^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_VariationMonthly("RSW_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
    
    def NDVI_MCD_Monthly0 (self):        
        # disp(sprintf('NDVI_MCD^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('NDVI_MCD^',year,month,0);    
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_VariationMonthly("NDVI_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
    
    def EMIS_MCD_Monthly0 (self):         
        # disp(sprintf('EMIS_MCD^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('EMIS_MCD^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_VariationMonthly("EMIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
    
    def RVIS_Daily (self): 
        # disp(sprintf('RVIS_Daily^, d02d',year,month)); 
        # f_RefDaily('RVIS_MCD^',year,month,0);     
        # f_RefDaily('RVIS_MCD^',year,month,1);  
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_VariationMonthly("RVIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0)
        
        tf = eng.f_VariationMonthly("RVIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,1) 
        
        eng.quit()
        
    def RNIR_Daily (self):  
        # disp(sprintf('RNIR_Daily^, d02d',year,month)); 
        # f_RefDaily('RNIR_MCD^',year,month,0);      
        # f_RefDaily('RNIR_MCD^',year,month,1); 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_RefDaily("RNIR_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0)
        
        tf = eng.f_RefDaily("RNIR_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,1) 
        
        eng.quit()
        
    def RSW_Daily (self):
        # disp(sprintf('RSW_Daily^, d02d',year,month)); 
        # f_RefDaily('RSW_MCD^',year,month,0);   
        # f_RefDaily('RSW_MCD^',year,month,1);  
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_RefDaily("RSW_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0)
        
        tf = eng.f_RefDaily("RSW_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,1) 
        
        eng.quit()
        
        
    def NDVI_Daily (self):
        # disp(sprintf('NDVI_Daily^, d02d',year,month)); 
        # f_RefDaily('NDVI_MCD^',year,month,0);    
        # f_RefDaily('NDVI_MCD^',year,month,1); 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_RefDaily("NDVI_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0)
        
        tf = eng.f_RefDaily("NDVI_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,1) 
        
        eng.quit()
        
        
    def EMIS_Daily (self): 
        # disp(sprintf('EMIS_Daily^, d02d',year,month)); 
        # f_RefDaily('EMIS_MCD^',year,month,0);   
        # f_RefDaily('EMIS_MCD^',year,month,1); 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_RefDaily("EMIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,0)
        
        tf = eng.f_RefDaily("EMIS_MCD^",self._bessObject.Year,
                                  self._bessObject.Month,1) 
        
        eng.quit()
        
    def LAI (self):            
        # disp(sprintf('LAI',year,month));
        # f_LAIFPAR(year,month,'LAI')
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LAIFPAR(self._bessObject.Year,
                                  self._bessObject.Month,'LAI') 
        
        eng.quit()
    
    def FPAR (self):         
        # disp(sprintf('FPAR',year,month));
        # f_LAIFPAR(year,month,'FPAR')
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LAIFPAR(self._bessObject.Year,
                                  self._bessObject.Month,'FPAR') 
        
        eng.quit()
        
    def LAI_MCD_Filter (self): 
        # disp(sprintf('LAI_MCD_Filter^, d02d',year,month)); 
        # f_LAIFPARFilter('LAI_MCD^',year,month,0);     
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LAIFPAR('LAI_MCD^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
    def f_LAIFPARFilter (self):         
        # disp(sprintf('FPAR_MCD_Filter^, d02d',year,month)); 
        # f_LAIFPARFilter('FPAR_MCD^',year,month,0);   
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LAIFPARFilter('FPAR_MCD^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()


    def LAI_MCD_Filter_Monthly (self):        
        # disp(sprintf('LAI_MCD_Filter^_Monthly, d02d',year,month));   
        # f_AverageMonthly('LAI_MCD_Filter^',year,month,0);   
         
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly('LAI_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
    def FPAR_MCD_Filter_Monthly (self):         
        # disp(sprintf('FPAR_MCD_Filter^_Monthly, d02d',year,month));   
        # f_AverageMonthly('FPAR_MCD_Filter^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly('FPAR_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
    def LAI_MCD_Filter_Monthly0 (self):
        # disp(sprintf('LAI_MCD_Filter^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('LAI_MCD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_VariationMonthly('LAI_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
        
    def FPAR_MCD_Filter_Monthly0 (self):        
        # disp(sprintf('FPAR_MCD_Filter^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('FPAR_MCD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_VariationMonthly('FPAR_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
    def LAI_Daily (self):
        # disp(sprintf('LAI_Daily^, d02d',year,month)); 
        # f_LAIFPARDaily('LAI_MCD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LAIFPARDaily('LAI_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
        
    def FPAR_Daily (self):
        # disp(sprintf('FPAR_Daily^, d02d',year,month)); 
        # f_LAIFPARDaily('FPAR_MCD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LAIFPARDaily('FPAR_MCD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
        
    def LAI_MOD_Filter (self):         
        # disp(sprintf('LAI_MOD_Filter^, d02d',year,month)); 
        # f_LAIFPARFilter('LAI_MOD^',year,month,0);    
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LAIFPARFilter('LAI_MOD^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
    def FPAR_MOD_Filter (self): 
        # disp(sprintf('FPAR_MOD_Filter^, d02d',year,month)); 
        # f_LAIFPARFilter('FPAR_MOD^',year,month,0);  
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LAIFPARFilter('FPAR_MOD^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit()
        
    def LAI_MOD_Filter_Monthly (self):
        # disp(sprintf('LAI_MOD_Filter^_Monthly, d02d',year,month));   
        # f_AverageMonthly('LAI_MOD_Filter^',year,month,2); 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LAIFPARFilter('LAI_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,2) 
        
        eng.quit()
    
    def FPAR_MOD_Filter_Monthly (self):        
        # disp(sprintf('FPAR_MOD_Filter^_Monthly, d02d',year,month));   
        # f_AverageMonthly('FPAR_MOD_Filter^',year,month,2); 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly('FPAR_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,2) 
        
        eng.quit() 
        
    def LAI_MOD_Filter_Monthly0 (self): 
        # disp(sprintf('LAI_MOD_Filter^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('LAI_MOD_Filter^',year,month,2);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_VariationMonthly('LAI_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,2) 
        
        eng.quit() 
        
    def FPAR_MOD_Filter_Monthly0 (self):
        # disp(sprintf('FPAR_MOD_Filter^_Monthly0, d02d',year,month));   
        # f_VariationMonthly('FPAR_MOD_Filter^',year,month,2);     

        eng = matlab.engine.start_matlab()
        
        tf = eng.f_VariationMonthly('FPAR_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,2) 
        
        eng.quit() 
        
    def LAI_Daily (self):
        # disp(sprintf('LAI_Daily^, d02d',year,month)); 
        # f_LAIFPARDaily('LAI_MOD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LAIFPARDaily('LAI_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit() 
        
    def FPAR_Daily (self):
        # disp(sprintf('FPAR_Daily^, d02d',year,month)); 
        # f_LAIFPARDaily('FPAR_MOD_Filter^',year,month,0);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LAIFPARDaily('FPAR_MOD_Filter^', self._bessObject.Year,
                                  self._bessObject.Month,0) 
        
        eng.quit() 
        
    def LST_AM (self):         
        # disp(sprintf('LST_AM^, d02d',year,month)); 
        # f_LSTDay(year,month,0,'MOD'); 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LSTDay(self._bessObject.Year,
                                  self._bessObject.Month,0,'MOD') 
        
        eng.quit() 
        
    def LST_PM (self):         
        # disp(sprintf('LST_PM^, d02d',year,month)); 
        # f_LSTDay(year,month,0,'MYD'); 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LSTDay(self._bessObject.Year,
                                  self._bessObject.Month,0,'MYD') 
        
        eng.quit() 
        
    def LST_Night (self): 
        # disp(sprintf('LST_Night, d02d',year,month)); 
        # f_LSTNight(year,month);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_LSTNight(self._bessObject.Year, self._bessObject.Month) 
        
        eng.quit() 
        
    def VTCI (self):
        # disp(sprintf('VTCI, d02d',year,month)); 
        # f_VTCI(year,month);

        eng = matlab.engine.start_matlab()
        
        tf = eng.f_VTCI(self._bessObject.Year, self._bessObject.Month) 
        
        eng.quit() 
        
    def AMSR2_SM (self): 
        # disp(sprintf('AMSR2-SM, d02d',year,month)); 
        # f_AMSR2(year,month);

        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AMSR2(self._bessObject.Year, self._bessObject.Month) 
        
        eng.quit() 
        
        
    def SMAP_SM (self):
        # disp(sprintf('SMAP-SM, d02d',year,month)); 
        # f_SMAP(year,month);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_SMAP(self._bessObject.Year, self._bessObject.Month) 
        
        eng.quit() 
        
    def SMOS_SM (self):
        # disp(sprintf('SMOS-SM, d02d',year,month)); 
        # f_SMOS(year,month); 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_SMOS(self._bessObject.Year, self._bessObject.Month) 
        
        eng.quit() 
        
    def SM0 (self) :
        # disp(sprintf('SM0, d02d',year,month)); 
        # f_SM0(year,month);
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_SM0(self._bessObject.Year, self._bessObject.Month) 
        
        eng.quit() 
        
    def SM_Daily (self):
        # disp(sprintf('SM_Daily, d02d',year,month)); 
        # f_SMDaily(year,month); 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_SMDaily(self._bessObject.Year, self._bessObject.Month) 
        
        eng.quit() 
        
    def SM_Lag30 (self):        
        # disp(sprintf('SM_Lag30, d02d',year,month)); 
        # f_Lag30('SM_Daily',year,month); 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_Lag30('SM_Daily',self._bessObject.Year, self._bessObject.Month) 
        
        eng.quit() 
        
    def LST_AM (self):        
        # disp(sprintf('LST_AM^, d02d',year,month)); 
        # f_LSTFill('LST_MOD^',year,month,0) 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_Lag30('LST_MOD^',self._bessObject.Year, self._bessObject.Month,0) 
        
        eng.quit() 
    
    def LST_PM (self):
        # disp(sprintf('LST_PM^, d02d',year,month)); 
        # f_LSTFill('LST_MYD^',year,month,0) 
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_Lag30('LST_MYD^',self._bessObject.Year, self._bessObject.Month,0) 
        
        eng.quit() 
        
        
 