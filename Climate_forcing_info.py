# -*- coding: utf-8 -*-
"""
Created on Mon Mar 22 12:59:32 2021

@author: Henock
"""

class Climate_forcing_info:
    
    def __init__(self,_bessObject):
        self._bessObject=_bessObject
        print("Climate_forcing_info")
        
    def generate_all_surface_info(self):
        print("Climate_forcing_info")

    def NIRDiff_AM_NIRDiff_PM_NIRDir_AM_NIRDir_PM(self):
        print("NIRDiff_AM_NIRDiff_PM_NIRDir_AM_NIRDir_PM")
        
    def PARDiff_AM_PARDiff_PM_PARDir_AM_PARDir_PM(self):
        print("PARDiff_AM_PARDiff_PM_PARDir_AM_PARDir_PM")
        
    def Rg_AM_Rg_PM_UV_AM_UV_PM(self):
        print("Rg_AM_Rg_PM_UV_AM_UV_PM")
    
    def Ta_Daily_Ta_PM_Ta_AM_Td_Daily_(self):
        print("Rg_AM_Rg_PM_UV_AM_UV_PM")
        
    def Td_AM_Td_PM_Ta_Lag30_Td_Lag30(self):
        print("Rg_AM_Rg_PM_UV_AM_UV_PM")
    
    def Ca(self):
        print("ca")
        
    def validate():
        print("Validation")
        
          
        
        
# disp('ssrd','t2m','d2m',year,month)
# f_ERA(year,month)
  
    def ssrd(self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_ERA(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        

# disp(sprintf('Ta_Daily, d02d',year,month)); 
# f_DownscaleERA5Daily(year,month,'Ta');
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_DownscaleERA5Daily(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        

# disp(sprintf('Td_Daily, d02d',year,month)); 
# f_DownscaleERA5Daily(year,month,'Td');
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('Rs_Daily, d02d',year,month)); 
# f_DownscaleERA5Daily(year,month,'Rs');
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('PAR_Daily, d02d',year,month)); 
# f_Calibrate('Rs_Daily',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('Ta_AM, d02d',year,month)); 
# f_DownscaleERA5Snapshot(year,month,'Ta','MOD')
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('Ta_PM, d02d',year,month)); 
# f_DownscaleERA5Snapshot(year,month,'Ta','MYD')
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('Td_AM, d02d',year,month)); 
# f_DownscaleERA5Snapshot(year,month,'Td','MOD')
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('Td_PM, d02d',year,month)); 
# f_DownscaleERA5Snapshot(year,month,'Td','MYD')
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('Radiation ERA, d02d',year,month));
# f_RadiationERA(year,month,'AM');
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('Radiation ERA, d02d',year,month));
# f_RadiationERA(year,month,'PM');
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('MODIS radiation stream',year,month));
# BESSRadiation(year, month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        

# disp(sprintf('Rg_AM, d02d',year,month));
# f_RadiationFill('Rg_AM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('Rg_PM, d02d',year,month));
# f_RadiationFill('Rg_PM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('UV_AM, d02d',year,month));
# f_RadiationFill('UV_AM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('UV_PM, d02d',year,month));
# f_RadiationFill('UV_PM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('PARDir_AM, d02d',year,month));
# f_RadiationFill('PARDir_AM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('PARDir_PM, d02d',year,month));
# f_RadiationFill('PARDir_PM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('PARDiff_AM, d02d',year,month));
# f_RadiationFill('PARDiff_AM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('PARDiff_PM, d02d',year,month));
# f_RadiationFill('PARDiff_PM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('NIRDir_AM, d02d',year,month));
# f_RadiationFill('NIRDir_AM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('NIRDir_PM, d02d',year,month));
# f_RadiationFill('NIRDir_PM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('NIRDiff_AM, d02d',year,month));
# f_RadiationFill('NIRDiff_AM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('NIRDiff_PM, d02d',year,month));
# f_RadiationFill('NIRDiff_PM',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('PAR_Lag30, d02d',year,month)); 
# f_Lag30('PAR_Daily',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('Ta_Lag30, d02d',year,month)); 
# f_Lag30('Ta_Daily',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('Td_Lag30, d02d',year,month)); 
# f_Lag30('Td_Daily',year,month);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        

# disp(sprintf('Rs_AM_Monthly, d02d',year,month));   
# f_AverageMonthly('Rs_AM',year,month,0);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('Rs_PM_Monthly, d02d',year,month));   
# f_AverageMonthly('Rs_PM',year,month,0);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('UV_ERA_AM_Monthly, d02d',year,month));   
# f_AverageMonthly('UV_ERA_AM',year,month,0);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('UV_ERA_PM_Monthly, d02d',year,month));   
# f_AverageMonthly('UV_ERA_PM',year,month,0);  

    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        

# disp(sprintf('PARDir_ERA_AM_Monthly, d02d',year,month));   
# f_AverageMonthly('PARDir_ERA_AM',year,month,0);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('PARDir_ERA_PM_Monthly, d02d',year,month));   
# f_AverageMonthly('PARDir_ERA_PM',year,month,0);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('PARDiff_ERA_AM_Monthly, d02d',year,month));   
# f_AverageMonthly('PARDiff_ERA_AM',year,month,0);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('PARDiff_ERA_PM_Monthly, d02d',year,month));   
# f_AverageMonthly('PARDiff_ERA_PM',year,month,0);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('NIRDir_ERA_AM_Monthly, d02d',year,month));   
# f_AverageMonthly('NIRDir_ERA_AM',year,month,0);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('NIRDir_ERA_PM_Monthly, d02d',year,month));   
# f_AverageMonthly('NIRDir_ERA_PM',year,month,0);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('NIRDiff_ERA_AM_Monthly, d02d',year,month));   
# f_AverageMonthly('NIRDiff_ERA_AM',year,month,0);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp(sprintf('NIRDiff_ERA_PM_Monthly, d02d',year,month));   
# f_AverageMonthly('NIRDiff_ERA_PM',year,month,0);
  
    def (self):        
        
        eng = matlab.engine.start_matlab()
        
        tf = eng.f_AverageMonthly(self._bessObject.Year,self._bessObject.Month,0) 
        
        eng.quit()
        
        
# disp('processing CO2')
# f_OCO2(year,month)
# f_NOAAbaseline(year,month)
# f_Ca_(year,month)
