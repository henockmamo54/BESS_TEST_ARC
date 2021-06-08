# -*- coding: utf-8 -*-
"""
Created on Fri Mar 19 17:06:47 2021

@author: Henock
"""

from Surface_status_info import Surface_status_info as surfaceinfo
from Climate_forcing_info import Climate_forcing_info as climateinfo


class BESS_Processor:
    
    def __init__(self,_bessObject): 
        self._bessObject=_bessObject 
        self._surfacestatusObject = surfaceinfo(self._bessObject)
        self._climateForcingInfoObject = climateinfo(self._bessObject)

    def Surface_status_info_generator_monthly(self):
        print("from =>> Surface_status_info_generator Monthly")
        self._surfacestatusObject.generate_all_surface_info_monthly(self._bessObject.Year,self._bessObject.Month)
    
    def Surface_status_info_generator_yearly(self):
        print("from =>> Surface_status_info_generator Yearly") 
        self._surfacestatusObject.generate_all_surface_info_yearly(self._bessObject.Year)
           
    
    def Climate_forcing_info_generator_monthly(self):
        print("from =>> Climate_forcing_info_generator Monthly")
        self._climateForcingInfoObject.generate_all_climate_forcing_info_monthly(self._bessObject.Year,self._bessObject.Month)
        
    def Climate_forcing_info_generator_yearly(self):
        print("from =>> Climate_forcing_info_generator Yearly")
        self._climateForcingInfoObject.generate_all_climate_forcing_info_yearly(self._bessObject.Year)
        
    
    def ancillary_info_generator(self):
        print("from =>> ancillary_info_generator")
        
        
        