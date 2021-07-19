# -*- coding: utf-8 -*-
"""
Created on Fri Mar 19 16:45:04 2021

@author: Henock
"""

# import BESS_Object as _bess 
import matlab.engine
import sys

class BESS_Generate:
    
    def __init__(self, bessObject): 
        self._bessObject = bessObject  
         

    def Generate_GPP_ET_005(self):
    
        print("Generate_GPP_ET_005\n","====><><><><><====== \n", self._bessObject.Year,
        						  self._bessObject.Month)  
                                  
        eng = matlab.engine.start_matlab()
        
        try:
            eng.BESS005d(self._bessObject.Year,
        						  self._bessObject.Month,nargout=0)
        except:
            print("Unexpected error:", sys.exc_info()[0])        
        
        print("done")
        
        eng.quit() 
        

    def Generate_GPP_ET_30s(self):
        print(self._bessObject.Year, " Generate_GPP_ET_305 ==> run the script 30s")