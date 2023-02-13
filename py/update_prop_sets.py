# This program is designed to update map_storage prop_sets based on
# RDA updates by storing the current data, updating the xml documents
# using xslt, and then comparing them to save deprecated properties
# that contain implementation sets
# last updated: 2/10/2023

import xml.etree.ElementTree as ET 
import os
from textwrap import dedent

#class to store properties 
from prop_storage import Prop
from store_props import store_props 
from add_props import add_prop

# just for testing
import sys

#compare two sets of properties and return ones in 1 not in 2
def compare_props(array1, array2):
    deprecated_props = []

    for index1, i in enumerate(array1):
        length = len(array2)
        for index2, j in enumerate(array2):
            if(i.prop_iri != j.prop_iri):
                length = length - 1
        if length == 0:
            deprecated_props.append(i)
    
    return deprecated_props

# get current xml files from path
path = './'
file_list = os.listdir(path)

### change when done testing 
file_list = [ elem for elem in file_list if (elem.startswith('prop_set_test'))]
#file_list = [ elem for elem in file_list if (elem.endswith('.xml') 
#    and (elem.startswith('prop_set_rd') or elem.startswith('prop_set_uw')))]

#create dictionary of arrays for each xml file
file_dict = {}
for f in file_list:
    file_dict[f] = []

#for each file, store current properties in array 
store_props(file_dict)

# """Setup and run XSLT transformation"""

# saxon_dir_prompt = dedent("""Enter the name of the directory in which the Saxon HE .jar file is stored
# For example: 'saxon', 'saxon11', etc.
# > """)
# saxon_dir = input(saxon_dir_prompt)

# saxon_version_prompt = dedent("""
# Enter the Saxon HE version number you'll use for the transformation
# For example: '11.1', '11.4', etc.
# > """)
# saxon_version = input(saxon_version_prompt)

# os.system(f'java -cp ~/{saxon_dir}/saxon-he-{saxon_version}.jar net.sf.saxon.Transform -t -s:xml/get_prop_sets.xml -xsl:xsl/001_01_build_update.xsl')

#get updated files
new_file_list = os.listdir(path)

### replace when done testing
new_file_list = [ elem for elem in file_list if (elem.startswith('prop_set_test1'))]
## not using dcterms or prov
# new_file_list = [ elem for elem in new_file_list if (elem.endswith('.xml') 
#     and (elem.startswith('prop_set_rd') or elem.startswith('prop_set_uw')))]

#create dictionary of arrays for each xml file
new_file_dict = {}
for f in new_file_list:
    new_file_dict[f] = []

#for each file, store current properties in array 
store_props(new_file_dict)

# del(file_dict)

#will have to iterate through all keys 

for key in file_dict.keys():
    array1 = []
    array2 = []
    array1 = file_dict.get(key)
    
    for new_key in new_file_dict.keys():
        if new_key == "prop_set_test1.xml":
            array2 = new_file_dict.get(new_key)
            #print(array2)
            # create storage for deprecated props
            deprecated_file_dict = {}
            for f in new_file_list:
                deprecated_file_dict[f] = []

            # compare props to find deprecated ones
            deprecated_props = compare_props(array1, array2)

            # add deprecated props back to updated files
            add_prop(new_key, deprecated_props)

### for testing
# array1 = file_dict.get("prop_set_test.xml")
# array2 = new_file_dict.get("prop_set_test1.xml")


