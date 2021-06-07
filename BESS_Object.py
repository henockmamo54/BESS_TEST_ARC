

# -*- coding: utf-8 -*-
"""
Created on Fri Mar 19 15:20:29 2021

@author: Henock
"""

class  BESS_Object:           
   def __init__(self, Year,Month,Day,OperationType):
     
       self.Path         = "../"          
       self.Year = Year  
       self.Month         = Month 
       self.Day           = Day 
       self.OperationType = OperationType
       self.Period        = "MODIS"
        
       self.OverpassMOD  = self.Path + "Ancillary/OverpassMOD.{}.mat".format(OperationType) 
       self.OverpassMYD  = self.Path + "Ancillary/OverpassMYD.{}.mat".format(OperationType)  
       self.LAT          = self.Path + "Ancillary/LAT.{}.mat".format(OperationType)        
       self.ALT          = self.Path + "Ancillary/ALT.{}.mat".format(OperationType)   
       self.Climate      = self.Path + "Ancillary/Climate.{}.mat".format(OperationType)  
       self.hc           = self.Path + "Ancillary/hc.{}.mat".format(OperationType)  
       self.fC4          = self.Path + "Ancillary/fC4InVeg.{}.mat".format(OperationType)  
       self.fTreesInVeg  = self.Path + "Ancillary/fTreesInVeg.{}.mat".format(OperationType)  
       self.fTreesInC3   = self.Path + "Ancillary/fTreesInC3.{}.mat".format(OperationType)  
       self.fCropsInC4   = self.Path + "Ancillary/fCropsInC4.{}.mat".format(OperationType)  
       self.Water        = self.Path + "Ancillary/Water.{}.mat".format(OperationType)  
       self.IGBP         = self.Path + "LC_MCD12C1/LC_MCD12C1.{}.mat ".format(Year)
       self.FNonVeg      = self.Path + "FNonVeg^_Trended/FNonVeg^_Trended.{}.mat".format(Year) 
       self.CI           = self.Path + "CI^_Clim/CI^_Clim.{:0>2}.mat".format(Month)           
       self.v            = self.Path + "v_Clim/v_Clim.{:0>2}.mat".format(Month)  
       self.SZAAM        = self.Path + "SZA_AM/SZA_AM.{:0>3}.mat".format(Day) 
       self.SZAPM        = self.Path + "SZA_PM/SZA_PM.{:0>3}.mat".format(Day) 
       self.LAI          = self.Path + "LAI_Daily^/LAI_Daily^.{}.{:0>3}.mat".format(Year,Day)
       self.RVIS         = self.Path + "RVIS_Daily^/RVIS_Daily^.{}.{:0>3}.mat".format(Year,Day)
       self.RNIR         = self.Path + "RNIR_Daily^/RNIR_Daily^.{}.{:0>3}.mat".format(Year,Day)
       self.RSW          = self.Path + "RSW_Daily^/RSW_Daily^.{}.{:0>3}.mat".format(Year,Day)
       self.RgDaily      = self.Path + "Rg_Daily/Rg_Daily.{}.{:0>3}.mat".format(Year,Day)
       self.TaDaily      = self.Path + "Ta_Daily/Ta_Daily.{}.{:0>3}.mat".format(Year,Day)
       self.TdDaily      = self.Path + "Td_Daily/Td_Daily.{}.{:0>3}.mat".format(Year,Day)
       self.RgAM         = self.Path + "Rg_AM/Rg_AM.{}.{:0>3}.mat".format(Year,Day)
       self.RgPM         = self.Path + "Rg_PM/Rg_PM.{}.{:0>3}.mat".format(Year,Day)
       self.UVAM         = self.Path + "UV_AM/UV_AM.{}.{:0>3}.mat".format(Year,Day)
       self.UVPM         = self.Path + "UV_PM/UV_PM.{}.{:0>3}.mat".format(Year,Day)
       self.PARDirAM     = self.Path + "PARDir_AM/PARDir_AM.{}.{:0>3}.mat".format(Year,Day)
       self.PARDirPM     = self.Path + "PARDir_PM/PARDir_PM.{}.{:0>3}.mat".format(Year,Day) 
       self.PARDiffAM    = self.Path + "PARDiff_AM/PARDiff_AM.{}.{:0>3}.mat".format(Year,Day) 
       self.PARDiffPM    = self.Path + "PARDiff_PM/PARDiff_PM.{}.{:0>3}.mat".format(Year,Day) 
       self.NIRDirAM     = self.Path + "NIRDir_AM/NIRDir_AM.{}.{:0>3}.mat".format(Year,Day) 
       self.NIRDirPM     = self.Path + "NIRDir_PM/NIRDir_PM.{}.{:0>3}.mat".format(Year,Day) 
       self.NIRDiffAM    = self.Path + "NIRDiff_AM/NIRDiff_AM.{}.{:0>3}.mat".format(Year,Day) 
       self.NIRDiffPM    = self.Path + "NIRDiff_PM/NIRDiff_PM.{}.{:0>3}.mat".format(Year,Day) 
       self.TaAM         = self.Path + "Ta_AM/Ta_AM.{}.{:0>3}.mat".format(Year,Day) 
       self.TaPM         = self.Path + "Ta_PM/Ta_PM.{}.{:0>3}.mat".format(Year,Day) 
       self.TdAM         = self.Path + "Td_AM/Td_AM.{}.{:0>3}.mat".format(Year,Day) 
       self.TdPM         = self.Path + "Td_PM/Td_PM.{}.{:0>3}.mat".format(Year,Day) 
       self.Vcmax25      = self.Path + "Vcmax25/Vcmax25/Vcmax25.{}.{:0>3}.mat".format(Year,Day) 
	   
	   
	   
	   
	   