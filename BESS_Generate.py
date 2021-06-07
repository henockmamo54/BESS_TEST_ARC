# -*- coding: utf-8 -*-
"""
Created on Fri Mar 19 16:45:04 2021

@author: Henock
"""

# import BESS_Object as _bess 

class BESS_Generate:
    
    def __init__(self, bessObject): 
        self._bessObject = bessObject  
         

    def Generate_GPP_ET_005(self):
        print(self._bessObject.Year, " Generate_GPP_ET_005 ==> run the script 005")
        

    def Generate_GPP_ET_30s(self):
        print(self._bessObject.Year, " Generate_GPP_ET_305 ==> run the script 30s")