        # -*- coding: utf-8 -*-
"""
Created on Mon Mar 22 12:59:32 2021

@author: Henock
"""


import matlab.engine
import sys

class Climate_forcing_info:
    
    def __init__(self,_bessObject):
        
        self._bessObject=_bessObject
        print("Climate_forcing_info")
        
    def generate_all_climate_forcing_info(self):
        print("Climate_forcing_info")
        
        
        eng = matlab.engine.start_matlab()
        
        try:
            print("1. f_ERA")
            eng.f_ERA(self._bessObject.Year,self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("2. f_DownscaleERA5Daily")
            eng.f_DownscaleERA5Daily(self._bessObject.Year,
                                           self._bessObject.Month,'Ta',nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("3. f_DownscaleERA5Daily")
            eng.f_DownscaleERA5Daily(self._bessObject.Year,        		
                                   self._bessObject.Month,'Td',nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("4. f_DownscaleERA5Daily")
            eng.f_DownscaleERA5Daily(self._bessObject.Year,
                                           self._bessObject.Month,'Rs',nargout=0)        
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
            
        try:
            print("5. f_Calibrate")
            eng.f_Calibrate( 'Rs_Daily', self._bessObject.Year,
                                  self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("6. f_DownscaleERA5Snapshot")
            eng.f_DownscaleERA5Snapshot(self._bessObject.Year,
                                              self._bessObject.Month,'Ta','MOD',nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("7. f_DownscaleERA5Snapshot")
            eng.f_DownscaleERA5Snapshot(self._bessObject.Year,
                                              self._bessObject.Month,'Ta','MYD',nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("8. f_DownscaleERA5Snapshot")
            eng.f_DownscaleERA5Snapshot(self._bessObject.Year,
                                              self._bessObject.Month,'Td','MOD',nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("9. f_DownscaleERA5Snapshot")
            eng.f_DownscaleERA5Snapshot(self._bessObject.Year,
                                              self._bessObject.Month,'Td','MYD',nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("10. f_RadiationERA")
            eng.f_RadiationERA(self._bessObject.Year,self._bessObject.Month,'AM',nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("11. f_RadiationERA")
            eng.f_RadiationERA(self._bessObject.Year,
                                      self._bessObject.Month,'PM',nargout=0)        
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        # # try:
            # # print("12. BESSRadiation")
            # # eng.BESSRadiation(self._bessObject.Year,self._bessObject.Month,nargout=0)
         # # except:
            # # print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("13. f_RadiationFill")
            eng.f_RadiationFill('Rg_AM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("14. f_RadiationFill")
            eng.f_RadiationFill('Rg_PM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("15. f_RadiationFill")
            eng.f_RadiationFill('UV_AM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("16. ")
            eng.f_RadiationFill('UV_PM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("17. ")
            eng.f_RadiationFill('PARDir_AM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("18. ")
            eng.f_RadiationFill('PARDir_PM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("19. ")
            eng.f_RadiationFill('PARDiff_AM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("20. ")
            eng.f_RadiationFill('PARDiff_PM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("21. ")
            eng.f_RadiationFill('NIRDir_AM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("22. ")
            eng.f_RadiationFill('NIRDir_PM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("23. ")
            eng.f_RadiationFill('NIRDiff_AM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("24. ")
            eng.f_RadiationFill('NIRDiff_PM',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("25. ")
            eng.f_Lag30('PAR_Daily',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("26. ")				  
            eng.f_Lag30('Ta_Daily',self._bessObject.Year,
                                      self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("27. ")				  
            eng.f_Lag30('Td_Daily',self._bessObject.Year,
                              self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("28. ")		 
            eng.f_AverageMonthly('Rs_AM',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("29. ")						  
            eng.f_AverageMonthly('Rs_PM',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("30. ")						  
            eng.f_AverageMonthly('UV_ERA_AM',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("31. ")						  
            eng.f_AverageMonthly('UV_ERA_PM',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("32. ")						  
            eng.f_AverageMonthly('PARDir_ERA_AM',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("33. ")						  
            eng.f_AverageMonthly('PARDir_ERA_PM',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try: 
            print("34. ")
            eng.f_AverageMonthly('PARDiff_ERA_AM',self._bessObject.Year, 
                                       self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("35. ")						  
            eng.f_AverageMonthly('PARDiff_ERA_PM',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("36")
            eng.f_AverageMonthly('NIRDir_ERA_AM',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("37")						  
            eng.f_AverageMonthly('NIRDir_ERA_PM',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
        try:
            print("38")							  
            eng.f_AverageMonthly('NIRDiff_ERA_AM',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("39")						  
            eng.f_AverageMonthly('NIRDiff_ERA_PM',self._bessObject.Year,
                                      self._bessObject.Month,0,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("40", "****no data for 2021 ***")
            eng.f_OCO2(self._bessObject.Year, self._bessObject.Month,nargout=0)        
        except:
            print("Unexpected error:", sys.exc_info()[0])
            
        try:
            print("41")
            eng.f_NOAAbaseline(self._bessObject.Year, self._bessObject.Month,nargout=0)        
        except:
            print("Unexpected error:", sys.exc_info()[0])
        
        try:
            print("42")
            eng.f_Ca_(self._bessObject.Year-2, self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])
                
        print("done")
        
        eng.quit()       
        

     
        
    def validate():
        print("Validation")
        
          
        
        
  
    def ssrd(self):    
        '''#disp('ssrd','t2m','d2m',year,month)
        #f_ERA(year,month)    '''
        
        eng = matlab.engine.start_matlab()
        
        eng.f_ERA(self._bessObject.Year,self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        

  
    def Ta_Daily(self):        
        '''#disp(sprintf('Ta_Daily, d02d',year,month)); 
        #f_DownscaleERA5Daily(year,month,'Ta');'''
        
        eng = matlab.engine.start_matlab()
        
        eng.f_DownscaleERA5Daily(self._bessObject.Year,
                                      self._bessObject.Month,'Ta',nargout=0)
        
        eng.quit()
        
        

    def Td_Daily(self):
        '''#disp(sprintf('Td_Daily, d02d',year,month)); 
        #f_DownscaleERA5Daily(year,month,'Td');'''
  
        eng = matlab.engine.start_matlab()
        
        eng.f_DownscaleERA5Daily(self._bessObject.Year,
                                      self._bessObject.Month,'Td',nargout=0)
        
        eng.quit()
        
        

  
    def Rs_Daily(self):        
        '''#disp(sprintf('Rs_Daily, d02d',year,month)); 
        #f_DownscaleERA5Daily(year,month,'Rs');'''

        eng = matlab.engine.start_matlab()
        
        eng.f_DownscaleERA5Daily(self._bessObject.Year,
                                      self._bessObject.Month,'Rs',nargout=0)
        
        eng.quit()
        
        
  
    def PAR_Daily(self):      
        '''#disp(sprintf('PAR_Daily, d02d',year,month)); 
        #f_Calibrate('Rs_Daily',year,month);  '''
                
        eng = matlab.engine.start_matlab()
        
        eng.f_Calibrate( 'Rs_Daily', self._bessObject.Year,
                             self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
  
    def Ta_AM(self):       
        
        '''#disp(sprintf('Ta_AM, d02d',year,month)); 
        #f_DownscaleERA5Snapshot(year,month,'Ta','MOD') '''
        
        eng = matlab.engine.start_matlab()
        
        eng.f_DownscaleERA5Snapshot(self._bessObject.Year,
                                         self._bessObject.Month,'Ta','MOD',nargout=0)
        
        eng.quit()
        
  
    def Ta_PM(self):        
                
        '''#disp(sprintf('Ta_PM, d02d',year,month)); 
        #f_DownscaleERA5Snapshot(year,month,'Ta','MYD')'''
        
        eng = matlab.engine.start_matlab()
        
        eng.f_DownscaleERA5Snapshot(self._bessObject.Year,
                                         self._bessObject.Month,'Ta','MYD',nargout=0)
        
        eng.quit()
        
        
  
    def Td_AM(self):        
        '''#disp(sprintf('Td_AM, d02d',year,month)); 
        #f_DownscaleERA5Snapshot(year,month,'Td','MOD')'''
        
        eng = matlab.engine.start_matlab()
        
        eng.f_DownscaleERA5Snapshot(self._bessObject.Year,
                                         self._bessObject.Month,'Td','MOD',nargout=0)
        
        eng.quit()
        
 
  
    def Td_PM(self):       
               
        '''#disp(sprintf('Td_PM, d02d',year,month)); 
        #f_DownscaleERA5Snapshot(year,month,'Td','MYD')'''
        
        eng = matlab.engine.start_matlab()
        
        eng.f_DownscaleERA5Snapshot(self._bessObject.Year,
                                         self._bessObject.Month,'Td','MYD',nargout=0)
        
        eng.quit()
        
        
  
    def Radiation_ERA_AM(self):        
        
        '''# disp(sprintf('Radiation ERA, d02d',year,month));
        # f_RadiationERA(year,month,'AM');'''
        
        eng = matlab.engine.start_matlab()
        
        eng.f_RadiationERA(self._bessObject.Year,self._bessObject.Month,'AM',nargout=0)
        
        eng.quit()
        
        
  
    def Radiation_ERA_PM(self):   
        
       # disp(sprintf('Radiation ERA, d02d',year,month));
       # f_RadiationERA(year,month,'PM');''' 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly(self._bessObject.Year,
                                  self._bessObject.Month,'PM',nargout=0)
        
        eng.quit()
        
        
    def MODIS_radiation_stream(self):        
        
        '''# disp(sprintf('MODIS radiation stream',year,month));
        # BESSRadiation(year, month);'''
  
        eng = matlab.engine.start_matlab()
        
        eng.BESSRadiation(self._bessObject.Year,self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        

    def Rg_AM(self):   
        
        '''# disp(sprintf('Rg_AM, d02d',year,month));
        # f_RadiationFill('Rg_AM',year,month);'''
   
        
        eng = matlab.engine.start_matlab()
        
        eng.f_RadiationFill('Rg_AM',self._bessObject.Year,
                                 self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def Rg_PM(self):        
        
        '''# disp(sprintf('Rg_PM, d02d',year,month));
        # f_RadiationFill('Rg_PM',year,month);'''
  
        eng = matlab.engine.start_matlab()
        
        eng.f_RadiationFill('Rg_PM',self._bessObject.Year,
                                 self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def UV_AM(self):        
        
        '''# disp(sprintf('UV_AM, d02d',year,month));
        # f_RadiationFill('UV_AM',year,month);'''
  
        eng = matlab.engine.start_matlab()
        
        eng.f_RadiationFill('UV_AM',self._bessObject.Year,
                                 self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def UV_PM(self):  
        
        '''# disp(sprintf('UV_PM, d02d',year,month));
        # f_RadiationFill('UV_PM',year,month);'''
    
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('UV_PM',self._bessObject.Year,
                                  self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def PARDir_AM(self): 
        
        '''# disp(sprintf('PARDir_AM, d02d',year,month));
        # f_RadiationFill('PARDir_AM',year,month);'''
      
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('PARDir_AM',self._bessObject.Year,
                                  self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def PARDir_PM(self):   
        
        '''# disp(sprintf('PARDir_PM, d02d',year,month));
        # f_RadiationFill('PARDir_PM',year,month);'''
   
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('PARDir_PM',self._bessObject.Year,
                                  self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def PARDiff_AM(self):   
        
        '''# disp(sprintf('PARDiff_AM, d02d',year,month));
        # f_RadiationFill('PARDiff_AM',year,month);'''
    
        
        eng = matlab.engine.start_matlab()
        
        eng.f_RadiationFill('PARDiff_AM',self._bessObject.Year,
                                  self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def PARDiff_PM(self): 
        
        '''# disp(sprintf('PARDiff_PM, d02d',year,month));
        # f_RadiationFill('PARDiff_PM',year,month);'''
  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_RadiationFill('PARDiff_PM',self._bessObject.Year,
                                 self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def NIRDir_AM(self):    
        
        '''# disp(sprintf('NIRDir_AM, d02d',year,month));
        # f_RadiationFill('NIRDir_AM',year,month);'''
    
        
        eng = matlab.engine.start_matlab()
        
        eng.f_RadiationFill('NIRDir_AM',self._bessObject.Year,
                                 self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def NIRDir_PM(self):  
        
        '''# disp(sprintf('NIRDir_PM, d02d',year,month));
        # f_RadiationFill('NIRDir_PM',year,month);'''
     
        
        eng = matlab.engine.start_matlab()
        
        eng.f_RadiationFill('NIRDir_PM',self._bessObject.Year,
                                  self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def NIRDiff_AM(self):        
        
        '''# disp(sprintf('NIRDiff_AM, d02d',year,month));
        # f_RadiationFill('NIRDiff_AM',year,month);'''
  
        eng = matlab.engine.start_matlab()
        
        eng.f_RadiationFill('NIRDiff_AM',self._bessObject.Year,
                                 self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
        
    def NIRDiff_PM(self):   
        
        '''# disp(sprintf('NIRDiff_PM, d02d',year,month));
        # f_RadiationFill('NIRDiff_PM',year,month);'''
   
        
        eng = matlab.engine.start_matlab()
        
        eng.f_RadiationFill('NIRDiff_PM',self._bessObject.Year,
                                  self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def PAR_Lag30(self): 
        
        '''# disp(sprintf('PAR_Lag30, d02d',year,month)); 
        # f_Lag30('PAR_Daily',year,month);'''
         
        
        eng = matlab.engine.start_matlab()
        
        eng.f_Lag30('PAR_Daily',self._bessObject.Year,
                                  self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def Ta_Lag30(self): 
        
        '''# disp(sprintf('Ta_Lag30, d02d',year,month)); 
        # f_Lag30('Ta_Daily',year,month);'''
      
        
        eng = matlab.engine.start_matlab()
        
        eng.f_Lag30('Ta_Daily',self._bessObject.Year,
                                  self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def Td_Lag30(self):  
        
        '''# disp(sprintf('Td_Lag30, d02d',year,month)); 
        # f_Lag30('Td_Daily',year,month);'''
       
        
        eng = matlab.engine.start_matlab()
        
        eng.f_Lag30('Td_Daily',self._bessObject.Year,
                         self._bessObject.Month,nargout=0)
        
        eng.quit()
        
        
    def Rs_AM_Monthly(self):     

        '''# disp(sprintf('Rs_AM_Monthly, d02d',year,month));   
        # f_AverageMonthly('Rs_AM',year,month,0);'''
     
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('Rs_AM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
        
    def Rs_PM_Monthly(self):  
        
        '''# disp(sprintf('Rs_PM_Monthly, d02d',year,month));   
        # f_AverageMonthly('Rs_PM',year,month,0);'''
        
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('Rs_PM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
    def UV_ERA_AM_Monthly(self):     
        
        '''# disp(sprintf('UV_ERA_AM_Monthly, d02d',year,month));   
        # f_AverageMonthly('UV_ERA_AM',year,month,0);'''
     
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('UV_ERA_AM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
        
    def UV_ERA_PM_Monthly(self):     
        
        '''# disp(sprintf('UV_ERA_PM_Monthly, d02d',year,month));   
        # f_AverageMonthly('UV_ERA_PM',year,month,0); ''' 

        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('UV_ERA_PM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
        

  
    def PARDir_ERA_AM_Monthly(self):     
        
        '''# disp(sprintf('PARDir_ERA_AM_Monthly, d02d',year,month));   
        # f_AverageMonthly('PARDir_ERA_AM',year,month,0);'''
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('PARDir_ERA_AM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
        
    def PARDir_ERA_PM_Monthly(self):     
        
        '''# disp(sprintf('PARDir_ERA_PM_Monthly, d02d',year,month));   
        # f_AverageMonthly('PARDir_ERA_PM',year,month,0);'''
     
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('PARDir_ERA_PM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
        
  
    def PARDiff_ERA_AM_Monthly(self):       
        
        '''# disp(sprintf('PARDiff_ERA_AM_Monthly, d02d',year,month));   
        # f_AverageMonthly('PARDiff_ERA_AM',year,month,0);'''
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('PARDiff_ERA_AM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
        
  
    def PARDiff_ERA_PM_Monthly(self):  
        
        '''# disp(sprintf('PARDiff_ERA_PM_Monthly, d02d',year,month));   
        # f_AverageMonthly('PARDiff_ERA_PM',year,month,0);''' 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('PARDiff_ERA_PM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
    def NIRDir_ERA_AM_Monthly(self):        
        
        '''# disp(sprintf('NIRDir_ERA_AM_Monthly, d02d',year,month));   
        # f_AverageMonthly('NIRDir_ERA_AM',year,month,0);'''
  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('NIRDir_ERA_AM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
        
    def NIRDir_ERA_PM_Monthly(self):        
        
        '''# disp(sprintf('NIRDir_ERA_PM_Monthly, d02d',year,month));   
        # f_AverageMonthly('NIRDir_ERA_PM',year,month,0);'''
  
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('NIRDir_ERA_PM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
    def NIRDiff_ERA_AM_Monthly(self):        
        
        '''# disp(sprintf('NIRDiff_ERA_AM_Monthly, d02d',year,month));   
        # f_AverageMonthly('NIRDiff_ERA_AM',year,month,0);'''
  
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('NIRDiff_ERA_AM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
        
  
    def NIRDiff_ERA_PM_Monthly(self):       
        '''# disp(sprintf('NIRDiff_ERA_PM_Monthly, d02d',year,month));   
        # f_AverageMonthly('NIRDiff_ERA_PM',year,month,0);''' 
        
        eng = matlab.engine.start_matlab()
        
        eng.f_AverageMonthly('NIRDiff_ERA_PM',self._bessObject.Year,
                                  self._bessObject.Month,0,nargout=0)
        
        eng.quit()
        
    
    def processing_CO2(self):        
        
        '''# disp('processing CO2')
        # f_OCO2(year,month)
        # f_NOAAbaseline(year,month)
        # f_Ca_(year,month)'''
        
        eng = matlab.engine.start_matlab()
        
        eng.f_OCO2(self._bessObject.Year, self._bessObject.Month,nargout=0)
        eng.f_NOAAbaseline(self._bessObject.Year, self._bessObject.Month,nargout=0)
        eng.f_Ca_(self._bessObject.Year, self._bessObject.Month,nargout=0)
        
        eng.quit()
        
