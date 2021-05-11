# -*- coding: utf-8 -*-
"""
Created on Fri May  7 08:12:42 2021

@author: Henock
"""

import os, os.path

def removeEmptyFiles(path):
    for root, _, files in os.walk(path):
        for f in files:
            fullpath = os.path.join(root, f)
            try:
                if os.path.getsize(fullpath) == 0:   #set file size in kb
                    print (fullpath)
                    os.remove(fullpath)
            except WindowsError:
                print ("Error" + fullpath)
                
                
path="C:/Users/Henock/Desktop/test"

removeEmptyFiles(path)
    