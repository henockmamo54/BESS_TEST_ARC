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

    def Surface_status_info_generator(self):
        print("from =>> Surface_status_info_generator")
        self._surfacestatusObject.generate_all_surface_info()
        
    
    def Climate_forcing_info_generator(self):
        print("from =>> Climate_forcing_info_generator")
        self._climateForcingInfoObject.generate_all_climate_forcing_info()
        
    
    def ancillary_info_generator(self):
        print("from =>> ancillary_info_generator")
        
        
        