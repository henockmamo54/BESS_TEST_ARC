# -*- coding: utf-8 -*-
"""
Created on Fri Mar 19 15:33:36 2021

@author: Henock
"""


import BESS_Object as _bess 
import BESS_Generate as generator
import BESS_Processor as processor
import Surface_status_info as surfaceinfo
import Climate_forcing_info as climateinfo
import ancillary_info as ancillaryinfo


 
myobject = _bess.BESS_Object(2021,1) 

# mygenerator= generator.BESS_Generate(myobject)
# mygenerator.Generate_GPP_ET_005()
# mygenerator.Generate_GPP_ET_30s()

myprocessor= processor.BESS_Processor(myobject)

myprocessor.Surface_status_info_generator_monthly()
# myprocessor.Surface_status_info_generator_yearly()

# myprocessor.Climate_forcing_info_generator_monthly()
# myprocessor.Climate_forcing_info_generator_yearly()


# mysurfaceinfo= surfaceinfo.Surface_status_info(myobject)
# mysurfaceinfo.RVIS_Daily_RNIR_Daily_RSW_Daily()
# mysurfaceinfo.RVIS_Daily_RNIR_Daily_RSW_Daily()
# mysurfaceinfo.RVIS_Daily_RNIR_Daily_RSW_Daily()

